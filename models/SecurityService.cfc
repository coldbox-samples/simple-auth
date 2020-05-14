component accessors="true" singleton {

	// Dependencies
	property name="sessionStorage" inject="SessionStorage@cbStorages";

	/**
	 * Constructor
	 */
	function init() {
		// Mock Security For Now
		variables.username = "luis";
		variables.password = "coldbox";

		return this;
	}

	/**
	 * Authorize with basic auth
	 */
	function authorize( username, password ) {
		// Validate Credentials, we can do better here
		if ( variables.username eq username AND variables.password eq password ) {
			// Set simple validation
			sessionStorage.set( "userAuthorized", true );
			return true;
		}

		return false;
	}

	/**
	 * Checks if user already logged in or not.
	 */
	function isLoggedIn() {
		return sessionStorage.get( "userAuthorized", "false" );
	}

}
