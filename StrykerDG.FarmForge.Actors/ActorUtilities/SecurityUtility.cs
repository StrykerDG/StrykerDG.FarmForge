using Microsoft.AspNetCore.Cryptography.KeyDerivation;
using System;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Text;

namespace StrykerDG.FarmForge.Actors.ActorUtilities
{
    public static class SecurityUtility
    {
        public static string GenerateSecurityTokenHash(string securityToken)
        {
            // Generate a salt
            byte[] salt;
            new RNGCryptoServiceProvider().GetBytes(salt = new byte[16]);
            var pbkdf2 = KeyDerivation.Pbkdf2(securityToken, salt, KeyDerivationPrf.HMACSHA256, 10000, 20);

            // Combine the salt and pbkdf2
            byte[] hashBytes = new byte[36];
            Array.Copy(salt, 0, hashBytes, 0, 16);
            Array.Copy(pbkdf2, 0, hashBytes, 16, 20);

            var hashedToken = Convert.ToBase64String(hashBytes);
            return hashedToken;
        }

        public static bool ValidateHashedToken(string hashedToken)
        {
            var hashedBytes = Convert.FromBase64String(hashedToken);

            var salt = new byte[16];
            Array.Copy(hashedBytes, 0, salt, 0, 16);

            var pbkdf2 = KeyDerivation.Pbkdf2(hashedToken, salt, KeyDerivationPrf.HMACSHA256, 10000, 20);

            for (int i = 0; i < 20; i++)
                if (hashedBytes[i + 16] != pbkdf2[i])
                    return false;

            return true;
        }
    }
}
