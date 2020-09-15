using System;
using System.Collections.Generic;
using System.Text;

namespace StrykerDG.FarmForge.Actors.Crops.Messages
{
    public class AskToCreateCrop
    {
        public int CropTypeId { get; private set; }
        public int VarietyId { get; private set; }
        public int LocationId { get; private set; }
        public int Quantity { get; private set; }
        public DateTime Date { get; private set; }

        public AskToCreateCrop(
            int cropTypeId,
            int varietyId,
            int locationId,
            int quantity,
            DateTime date
        )
        {
            CropTypeId = cropTypeId;
            VarietyId = varietyId;
            LocationId = locationId;
            Quantity = quantity;
            Date = date;
        }
    }
}
