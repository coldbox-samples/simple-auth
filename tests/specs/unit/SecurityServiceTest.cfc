/**
 * The base model test case will use the 'model' annotation as the instantiation path
 * and then create it, prepare it for mocking and then place it in the variables scope as 'model'. It is your
 * responsibility to update the model annotation instantiation path and init your model.
 */
component extends="coldbox.system.testing.BaseModelTest" model="models.SecurityService" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll() {
		super.beforeAll();

		// setup the model
		super.setup();

		mockSession = createMock( "modules.cbstorages.models.SessionStorage" )
	}

	function afterAll() {
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run() {
		describe( "SecurityService Suite", function() {
			beforeEach( function( currentSpec ) {
				model.init();
				model.setSessionStorage( mockSession );
			} );

			it( "can be created (canary)", function() {
				expect( model ).toBeComponent();
			} );

			it( "should authorize valid credentials", function() {
				mockSession.$( "set", mockSession );
				expect( model.authorize( "luis", "coldbox" ) ).toBeTrue();
			} );

			it( "should not authorize invalid credentials ", function() {
				expect( model.authorize( "test", "test" ) ).toBeFalse();
			} );

			it( "should verify if you are logged in", function() {
				mockSession.$( "get", true );
				expect( model.isLoggedIn() ).toBeTrue();
			} );

			it( "should verify if you are NOT logged in", function() {
				mockSession.$( "get", false );
				expect( model.isLoggedIn() ).toBeFalse();
			} );
		} );
	}

}
