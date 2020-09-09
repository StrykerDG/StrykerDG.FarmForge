using Akka.Actor;
using Microsoft.AspNetCore.Cryptography.KeyDerivation;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using StrykerDG.FarmForge.Actors.Authentication.Messages;
using StrykerDG.FarmForge.DataModel.Contexts;
using StrykerDG.FarmForge.DataModel.Models;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;

namespace StrykerDG.FarmForge.Actors.Authentication
{
    public class AuthenticationActor : FarmForgeActor
    {
        private AuthenticationSettings Settings { get; set; }

        public AuthenticationActor(
            IServiceScopeFactory factory, 
            AuthenticationSettings settings
        ) : base(factory)
        {
            Settings = settings;

            Receive<AskToLogin>(HandleLogin);
        }

        // Message Methods
        public void HandleLogin(AskToLogin message)
        {
            try
            {
                if (message.Username == null || message.Password == null)
                    throw new Exception("Username and Password must be present");

                Using<FarmForgeDataContext>((context) =>
                {
                    var existingUser = context.Users
                        .Where(u => u.Username == message.Username)
                        .FirstOrDefault();

                    if (existingUser == null)
                        throw new UnauthorizedAccessException("User not found");

                    if (!ValidatePassword(existingUser.Password, message.Password))
                        throw new UnauthorizedAccessException("Username or password is incorrect");

                    var token = GenerateToken(existingUser);

                    Sender.Tell(token);
                });
            }
            catch(Exception ex)
            {
                Sender.Tell(ex.Message);
            }
        }

        // Helper Methods
        private bool ValidatePassword(string dbPassword, string providedPassword)
        {
            var hashedBytes = Convert.FromBase64String(dbPassword);
            
            var salt = new byte[16];
            Array.Copy(hashedBytes, 0, salt, 0, 16);

            var pbkdf2 = KeyDerivation.Pbkdf2(providedPassword, salt, KeyDerivationPrf.HMACSHA256, 10000, 20);
            
            for(int i = 0; i < 20; i++)
                if (hashedBytes[i + 16] != pbkdf2[i])
                    return false;

            return true;
        }

        private string CreatePasswordHash(string password)
        {
            // Generate salt
            byte[] salt;
            new RNGCryptoServiceProvider().GetBytes(salt = new byte[16]);
            var pbkdf2 = KeyDerivation.Pbkdf2(password, salt, KeyDerivationPrf.HMACSHA256, 10000, 20);

            // Combine the two 
            byte[] hashBytes = new byte[36];
            Array.Copy(salt, 0, hashBytes, 0, 16);
            Array.Copy(pbkdf2, 0, hashBytes, 16, 20);

            var savedHash = Convert.ToBase64String(hashBytes);
            return savedHash;
        }

        private string GenerateToken(User user)
        {
            var secretKey = new SymmetricSecurityKey(Encoding.ASCII.GetBytes(Settings.SecretKey));
            var signingCredentials = new SigningCredentials(secretKey, SecurityAlgorithms.HmacSha256);

            // Add claims
            var claims = new List<Claim>
            {
                new Claim("User", user.Username),
            };

            var tokenOptions = new JwtSecurityToken(
                issuer:  Settings.Issuer,
                audience: Settings.Audience,
                claims: claims,
                expires: DateTime.Now.AddHours(1),
                signingCredentials: signingCredentials
            );

            var handler = new JwtSecurityTokenHandler();
            var tokenString = handler.WriteToken(tokenOptions);

            return tokenString;
        }
    }
}
