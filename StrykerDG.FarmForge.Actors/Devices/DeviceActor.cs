﻿using Akka.Actor;
using Microsoft.Extensions.DependencyInjection;
using Newtonsoft.Json;
using RestSharp;
using StrykerDG.FarmForge.Actors.ActorUtilities;
using StrykerDG.FarmForge.Actors.Devices.Messages;
using StrykerDG.FarmForge.DataModel.Contexts;
using StrykerDG.FarmForge.DataModel.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;

namespace StrykerDG.FarmForge.Actors.Devices
{
    public class DeviceActor : FarmForgeActor
    {
        public DeviceActor(IServiceScopeFactory factory) : base(factory)
        {
            Receive<AskToRegisterDevice>(RegisterDevice);
        }

        // Message Methods
        public void RegisterDevice(AskToRegisterDevice message)
        {
            // TODO: Return information instead of true / false
            // Make sure we have everything needed
            if(
                message.DeviceName == null || 
                message.IpAddress == null || 
                message.SerialNumber == null ||
                message.SecurityToken == null
            )
            {
                Sender.Tell(false);
                return;
            }


            Using<FarmForgeDataContext>((context) =>
            {
                // See if the device has been registered before
                var registeredDevice = context.Devices
                    .Where(d =>
                        d.Name == message.DeviceName &&
                        d.SerialNumber == message.SerialNumber &&
                        d.IsDeleted == false
                    )
                    .FirstOrDefault();

                var connectedStatus = context.Statuses
                    .Where(s =>
                        s.EntityType == "Device.Status" &&
                        s.Name == "connected" &&
                        s.IsDeleted == false
                    )
                    .Select(s => s.StatusId)
                    .FirstOrDefault();

                // If it has, update the token, ip, and status
                if (registeredDevice != null)
                {
                    // TODO: Hash the security token?
                    // var hashedToken = SecurityUtility.GenerateSecurityTokenHash(message.SecurityToken);

                    registeredDevice.IpAddress = message.IpAddress;
                    registeredDevice.SecurityToken = message.SecurityToken;
                    registeredDevice.StatusId = connectedStatus;

                    context.SaveChanges();
                }
                // Otherwise, request the device information and create a new device
                else
                {
                    try
                    {
                        // TODO: Wrap in a transaction
                        var interfaces = GetDeviceInterfaces(context, message);
                        var newDevice = context.Devices.Add(new Device
                        {
                            Name = message.DeviceName,
                            IpAddress = message.IpAddress,
                            SerialNumber = message.SerialNumber,
                            SecurityToken = message.SecurityToken,
                            StatusId = connectedStatus
                        }).Entity;

                        // Save to generate an ID for newDevice
                        context.SaveChanges();

                        foreach (var deviceInterface in interfaces)
                        {
                            // TODO: implement interface types
                            context.Interfaces.Add(new Interface
                            {
                                DeviceId = newDevice.DeviceId,
                                Name = deviceInterface.Name,
                                SerialNumber = deviceInterface.SerialNumber
                            });
                        }

                        context.SaveChanges();
                    }
                    catch (Exception ex)
                    {
                        var logMessage = "Error Registering Device";
                        var logData = new
                        {
                            ex.Message,
                            InnerException = ex.InnerException?.ToString(),
                            ex.StackTrace
                        };
                        var logDataString = JsonConvert.SerializeObject(logData);

                        context.Logs.Add(new Log
                        {
                            Message = logMessage,
                            Data = logDataString
                        });

                        context.SaveChanges();
                    }
                }

                Sender.Tell(true);
            });
        }

        // Helper Methods
        private List<Interface> GetDeviceInterfaces(FarmForgeDataContext context, AskToRegisterDevice message)
        {
            var client = new RestClient(new Uri($"http://{message.IpAddress}"));
            var request = new RestRequest($"{message.InterfaceEndpoint}", Method.GET);
            // TODO: Add security
            // request.AddHeader("Authorization", message.SecurityToken);

            // TODO: Make the conversion more resilient
            IRestResponse response = client.Execute(request);
            if (response.StatusCode == HttpStatusCode.OK)
                return JsonConvert.DeserializeObject<List<Interface>>(response.Content);
            else
            {
                var logMessage = $"Error getting Interfaces from {message.DeviceName}:{message.IpAddress}";
                var logData = new
                {
                    Response = response.StatusCode.ToString(),
                    response?.Content,
                    response?.ErrorMessage
                };
                var logDataString = JsonConvert.SerializeObject(logData);

                context.Logs.Add(new Log
                {
                    Message = logMessage,
                    Data = logDataString
                });

                context.SaveChanges();

                return new List<Interface>();
            }
        }
    }
}
