/**
 * Intercepts with HTTP Basic Authentication
 */
component {

	// Security Service
	property name="securityService" inject="provider:SecurityService";

	void function configure() {
	}

	void function preProcess( event, interceptData, rc, prc ) {
		// Verify Incoming Headers to see if we are authorizing already or we are already Authorized
		if ( !securityService.isLoggedIn() OR len( event.getHTTPHeader( "Authorization", "" ) ) ) {
			// Verify incoming authorization
			var credentials = event.getHTTPBasicCredentials();
			if ( securityService.authorize( credentials.username, credentials.password ) ) {
				// we are secured woot woot!
				return;
			};

			// Not secure!
			event.setHTTPHeader(
				name  = "WWW-Authenticate",
				value = "basic realm=""Please enter your username and password for our Cool App!"""
			);

			// secured content data and skip event execution
			event
				.renderData(
					data       = "<h1>Unathorized Access<p>Content Requires Authentication</p>",
					statusCode = "401",
					statusText = "Unauthorized"
				)
				.noExecution();
		}
	}

}
