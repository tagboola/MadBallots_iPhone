NSString * const PERSISTENCE_TOKEN_KEY = @"MBPersistenceToken";
NSString * const USER_ID_KEY = @"userId";
NSString * const USERNAME_KEY = @"username";
NSString * const PASSWORD_KEY = @"password";
NSString * const NAME_KEY = @"name";
NSString * const EMAIL_KEY = @"email";
NSString * const FACEBOOK_ID_KEY = @"facebookId";
#if TARGET_IPHONE_SIMULATOR
 NSString * const BASE_URL = @"http://localhost:3000";
#else
 NSString * const BASE_URL = @"http://24.60.153.138:3000";
#endif


NSString * const DEFAULT_NUMBER_OF_ROUNDS = @"10";

//Facebook Constants
NSString * const FACEBOOK_APP_ID= @"326482770747193";
NSString * const FACEBOOK_ACCESS_TOKEN_KEY = @"FBAccessTokenKey";
NSString * const FACEBOOK_EXIPIRATION_DATE_KEY = @"FBExpirationDateKey";

//Authentication Constants
NSString * const MAD_BALLOTS_AUTH_PROVIDER_STRING = @"mad_ballots";
NSString * const FACEBOOK_AUTH_PROVIDER_STRING = @"facebook";
NSString * const LOGOUT_RESPONSE_STRING = @"Successfully logged out";


NSString * const MB_NOTIFICATION_ACTION_IDENTIFIER_VOTE = @"vote";
NSString * const MB_NOTIFICATION_ACTION_IDENTIFIER_FILL_CARD = @"fill_card";
NSString * const MB_NOTIFICATION_ACTION_IDENTIFIER_RSVP = @"rsvp";
