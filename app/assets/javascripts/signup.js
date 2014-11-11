var ErrorAlertItem = React.createClass({
    render: function() {
        console.log(this.props.message);
        return (
            React.DOM.li(null, this.props.message)
            // <li> { this.props.message } </li>
        );
    }
});

var ErrorAlert = React.createClass({
    render: function() {
        var errors = this.props.errors.map(function(e) {
            return ErrorAlertItem({message: e});
        });

        console.log(errors);
        
        return (
            React.DOM.ul(null, errors)
            // <ul>
            //     { errors }
            // </ul>
        );
    }
});

var SuccessAlert = React.createClass({
    render: function() {
        return( React.DOM.div(null, "Success! We've added you to our beta users list!"));
    }
});


// for signing up users
$('body').on('click', "#joinButton", function(event) {
    event.preventDefault();
    form = $(this).closest('.BetaSignup').find('#betaSignupForm');
    console.log(form);
    handle_signup_form(form, "/users/create_beta", function(data) {
        $('#formSuccess').removeClass("Hidden");
        $('#formError').addClass("Hidden");
        React.renderComponent (
            SuccessAlert({}),
            document.getElementById('formSuccess')
        );
    });
});

// for signing up artists
$('body').on('click', "#signupButton", function(event) {
    event.preventDefault();
    form = $(this).closest('.ArtistSignup').find('#artistSignupForm');
    console.log(form);
    handle_signup_form(form, "/artists", function(data) {
        //TODO: replace with artist route
        window.location.replace(data.route);
    });
});

// for logging in artists
$('body').on('click', "#loginButton", function(event) {
    event.preventDefault();
    form = $(this).closest('.ArtistLogin').find('#artistLoginForm');
    console.log(form);
    handle_signup_form(form, "/artists/login", function(data) {
        //TODO: replace with artist route
        window.location.replace(data.route);
    });
});


var request = false;

function handle_signup_form(form, url, successHandler) {

    
    // # abort any pending request
    if (request) {
        request.abort();
    }


    // # setup some local variables
    // # let's select and cache all the fields
    var inputs = form.find("input, select, button, textarea");
    // # serialize the data in the form
    var serializedData = form.serialize();
    console.log('Serialized: ' + serializedData);

    // # let's disable the inputs for the duration of the ajax request
    inputs.prop("disabled", true);

    // # fire off the request to url
    request = $.ajax({
        url: url,
        type: "POST",
        data: serializedData,
        datatype: "JSON",
        success: function(data) {
            console.log(data);
            
            if(data.success) {
                successHandler(data);
            } else {
                $('#formSuccess').addClass("Hidden");
                $('#formError').removeClass("Hidden");
                React.renderComponent (
                    ErrorAlert({errors: data.errors}),
                    document.getElementById('formError')
                );
            }
        }
    });

    // # callback handler that will be called on failure
    request.fail(function (jqXHR, textStatus, errorThrown){
        // # log the error to the console
        console.error(
            "The following error occured: " +
                textStatus, errorThrown
        );
    });

    // # callback handler that will be called regardless
    // # if the request failed or succeeded
    request.always(function () {
        // # reenable the inputs
        inputs.prop("disabled", false);
    });

}
