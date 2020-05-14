component extends="coldbox.system.testing.BaseInterceptorTest" interceptor="interceptors.SimpleSecurity" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll() {
		super.beforeAll();

		// mock security service
		mockSecurityService = createEmptyMock( "models.SecurityService" );
	}

	function afterAll() {
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run() {
		describe( "SimpleSecurity Interceptor Suite", function() {
			beforeEach( function( currentSpec ) {
				// Setup the interceptor target
				super.setup();
				// inject mock into interceptor
				interceptor.$property(
					"securityService",
					"variables",
					mockSecurityService
				);
				mockEvent = getMockRequestContext();
			} );

			it( "can be created (canary)", function() {
				expect( interceptor ).toBeComponent();
			} );

			it( "can allow already logged in users", function() {
				// test already logged in and mock authorize so we can see if it was called
				mockSecurityService.$( "isLoggedIn", true ).$( "authorize", false );
				// call interceptor
				interceptor.preProcess( mockEvent, {} );
				// verify nothing called
				expect( mockSecurityService.$never( "authorize" ) ).toBeTrue();
			} );

			it( "will challenge if you are not logged in and you don't have the right credentials", function() {
				// test NOT logged in and NO credentials, so just challenge
				mockSecurityService.$( "isLoggedIn", false ).$( "authorize", false );
				// mock incoming headers and no auth credentials
				mockEvent
					.$( "getHTTPHeader" )
					.$args( "Authorization" )
					.$results( "" )
					.$( "getHTTPBasicCredentials", { username : "", password : "" } )
					.$( "setHTTPHeader" );
				// call interceptor
				interceptor.preProcess( mockEvent, {} );
				// verify authorize called once
				expect( mockSecurityService.$once( "authorize" ) ).toBeTrue();
				// Assert Set Header
				expect( mockEvent.$once( "setHTTPHeader" ) ).toBeTrue();
				// assert renderdata
				expect( mockEvent.getRenderData().statusCode ).toBe( 401 );
			} );

			it( "should authorize if you are not logged in but have valid credentials", function() {
				// Test NOT logged in With basic credentials that are valid
				mockSecurityService.$( "isLoggedIn", false ).$( "authorize", true );
				// reset mocks for testing
				mockEvent
					.$( "getHTTPBasicCredentials", { username : "luis", password : "luis" } )
					.$( "setHTTPHeader" );
				// call interceptor
				interceptor.preProcess( mockEvent, {} );
				// Assert header never called.
				expect( mockEvent.$never( "setHTTPHeader" ) ).toBeTrue();
			} );
		} );
	}

}
