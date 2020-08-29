#include <Arduino.h>
#include "FarmForge.h"

class BaseDevice {
    public:
        BaseDevice();
        unsigned long long GetNumberOfInterfaces();
        String GetInterfaceName(int index);

    private:
        Interface interfaces[2];
};
