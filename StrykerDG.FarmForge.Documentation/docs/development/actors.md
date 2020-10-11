---
id: 'actors'
title: 'Actors'
sidebar_label: 'Actors'
---

## Introduction

The actor system is where all "business logic" resides for FarmForge. The reason
for this is to keep the logic in a central location that can be accessed from 
anywhere. 

This makes it available not only to the local API, but also websocket requests 
from FarmForge IoT devices, as well as requests from the external API, should 
an individual decide that they want to connect their local installation to the 
outside world.

## Actor Structure

Each actor is setup following a similar pattern, and inherits from the FarmForge
actor, which provides some common functionality.

```
public class DemoActor : FarmForgeActor
{
    // Constructor
    // Message Methods
    // Helper Methods
}
```

### Constructor

The constructor takes in an IServiceScopeFactory and sets up all of the various 
"Receive" methods

```
public DemoActor(IServiceScopeFactory factory) : base(factory)
{
    Receive<AskForDemo>(HandleAskForDemo);
}
```

### Message Methods

The message methods are the methods called from Receive and contain the logic
for whatever action is being performed.

```
private void HandleAskForDemo(AskForDemo message) 
{
    Using<FarmForgeDataContext>((context) =>
    {
        var results = context.Demos
            .ToList();

        Sender.Tell(results);
    });
}
```

### Helper Methods

Helper methods are functions that are either used in multiple message methods,
or to move logic out of the message methods to keep the code more readable