import 'package:googleapis_auth/auth_io.dart';

class Getserverkey {
  Future<String> getServerKeyToken() async {
    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];

    final client =await clientViaServiceAccount(ServiceAccountCredentials.fromJson(
        {
          "type": "service_account",
          "project_id": "get-pass-e77e5",
          "private_key_id": "f0b88a367d11dae57627e25a91581658ea86422e",
          "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC71U4fWRGh635+\nf5A2fxS2l+kXBv/32+G3TlO66+CgrAi2l7b/AmK7lT0GwCs9FWfMtAFVw6Xn4Dl6\nTvqXcx2mCuFqzq/pCEeKNgb7FBBvzl+TClce0iTOY9jYf2PGOhwfk3eI9pz3sYgN\no1x4hu6gITiKFZwDEo66kP75uoyastAEQl2CT6sRzmqyn6uzrHPGJpIv0JdRSbX9\nxbG6E6t3BUvuOQfmRFfPeWhSOcMQ634Yrc7aRhYhUPgP6Uf+KaE6/05UVoqSESgc\nAfKIbx9M6ibKy0cOEDcehEIwxn0zHEHSzhRGyXL8iKj+sxoggA/StzMb1feZJ1VQ\nIoLpsWkXAgMBAAECggEAMOwaSGzs/ET3ceAswhzwWqyPX9mJYtfI3vMOOOHF5GNa\nc6BpX9sRtzTkK7VyrZq9KeJ6dImcVRwgLFyUxUyM3Nn5o1WJGMN4yqVOxSeRLmXM\nm+I2Fcd7Iax85sqrRI6PE6RXnntJH/SD8LVrWNMgJOHyNXjyZRR4y1wHpSizBXl6\nGVclOXhwRml1pfWuw/pK2Jf0q8QgvTJzJoRgIjWKrxVSdfGHoY+oH1TXW2RiRDrW\nH1PnhJq29q56cfe4RUfqkHykSu0rLn5gh2ofUwO/u0XbjH5EK1Rm9CUBFNbcfPn+\niaAw7AuqwiIUvKY+batTwu33MicrKJuoeWaax1dhTQKBgQDev0mivjevK6cqAqXt\n/fVdSrigzY5B+Z4d6hXZHszr0wgj3PAmj/378WeiCqWt24p/l3R5LsBig8ZS+89k\nWChPTgT7+QUl7FrEi7OmMTOyZ2nFy61AvGwE1aG2Mb+PuLxphky2LHuTfo9cVi5n\nSukexu+dXlSR2PDfZTK6Wj8INQKBgQDX37ZVqJX3haIiRg7kRBnGKikyplA2pxY2\nsOm0Se9Kzt/KbTReuOqpTL59k19L9nSNmd85c7phHZsvaKtr6IgD1cngJGPgPzIz\nVbc/SIp9EiuUAVy4JoPVxZjtngn9Xs0+eZ82QDWFHr32uBYH4Qdk2loX/eoPd0wu\n6yr9rMHNmwKBgQCGTbn9WUnD4cMx7lTT0YsOzA3UTvxWRUaT7N9tgUe3bQ98aCuY\nZLuUHDMLHfZVhIjWc6BzrL+s5p0+zbt3Wjw7zOPudXAoNIFp/n28V/A+wmGhNDRr\nUvCiXZjafNZutslLqwE32kxMW0PfPctO1nkG6JXzQbwmEDLzz1WtzNoyfQKBgFzA\n67gsYpti2MI/NeDQff6OWPtBSI/jBQFkzFXBusZ60t9IQss8St+JcQPF0ZlzAKti\n5O3rkrZtoSMipx0LYX28Wywqlptgq/IwrzbKtW594ymJ2EvriJPOfiIC2Kn8FNX2\nLfmCZzyWc+rRN+4UuzeTNki+udYBXUN/mg47L15nAoGBAK/ug+FcHBA3aegFwNfj\nLCs8MNa7PXHVL/7FvRoFweOZ7w6OhQJ/C2iC3J7m7SoOUBj3/A2WnGarnN2dgbKo\neaXupJ/kULzvGch638onQjI3VU/zcXX/ARJntePyOC4T0vfoTMnyvvuLvRu1Pf5s\nq+lf5LPSuHYDD+/RMsZbBqB7\n-----END PRIVATE KEY-----\n",
          "client_email": "firebase-adminsdk-xa9v4@get-pass-e77e5.iam.gserviceaccount.com",
          "client_id": "114819880818317747824",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-xa9v4%40get-pass-e77e5.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com"
        }
    ), scopes);

    final accessKey=client.credentials.accessToken.data;
    return accessKey;
  }
}