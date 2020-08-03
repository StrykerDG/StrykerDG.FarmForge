using System.Collections.Generic;

namespace StrykerDG.FarmForge.LocalApi.Configuration
{
    public class ApiSettings
    {
        public int MajorVersion { get; set; }
        public int MinorVersion { get; set; }
        public SwaggerSettings SwaggerSettings { get; set; }
        public Dictionary<string, string> ConnectionStrings { get; set; }
    }
}
