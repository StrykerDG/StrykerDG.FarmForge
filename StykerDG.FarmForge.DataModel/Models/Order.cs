using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text;

namespace StrykerDG.FarmForge.DataModel.Models
{
    [Table("Order")]
    public class Order : BaseModel
    {
        [Key]
        public int OrderId { get; set; }
        public int CustomerId { get; set; }
        public string OrderNumber { get; set; }
        public double Total { get; set; }
        public ICollection<ProductDestination> Products { get; set; }
        public ICollection<Payment> Payments { get; set; }
    }
}
