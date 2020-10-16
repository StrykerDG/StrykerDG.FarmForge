using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text;

namespace StrykerDG.FarmForge.DataModel.Models
{
    [Table("Payment")]
    public class Payment : BaseModel
    {
        [Key]
        public int PaymentId { get; set; }
        public int OrderId { get; set; }
        public double Amount { get; set; }
    }
}
