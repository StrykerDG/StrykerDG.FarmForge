using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text;
using System.Text.Json.Serialization;

namespace StrykerDG.FarmForge.DataModel.Models
{
    [Table("User")]
    public class User : BaseModel
    {
        [Key]
        public int UserId { get; set; }
        public string Username { get; set; }
        [JsonIgnore]
        public string Password { get; set; }
    }
}
