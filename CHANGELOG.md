# CHANGELOG


## 1.4.0 (12 October 2016)

* Internationalise emails' subject lines.


## 1.3.2 (22 July 2015)

* Loosen Rails dependency.
* Remove unnecessary code from test app.


## 1.3.1 (22 July 2015)

* Prefer an instance method to prepare for activation.


## 1.3.0 (23 May 2013)

* Validate username's uniqueness case-insensitively.


## 1.2.3 (21 March 2013)

* Ability to override the activation email's from and subject.


## 1.2.2 (20 March 2013)

* Enable form validation errors in activation form.
* Increase time limit for password reset / activation to 24hr.


## 1.2.1 (15 August 2012)

* Ignore blank usenames when authenticating.


## 1.2.0 (18 July 2012)

* User activation.


## 1.1.2 (7 February 2012)

* Replace ActiveSupport::SecureRandom with SecureRandom.


## 1.1.1 (18 October 2011)

* Only change password when a non-blank value is given.
* Add `authenticated?` helper method.


## 1.1.0 (7 October 2011)

* Correctly handle blank username in password reset.
* Allow configuration of cookie domain.
* Pass controller to signed_{in,out}_url to allow routes with options/parameters.
* Fix bug where `signed_in_url` config setting was overwritten.
* Harmonise bcrypt-ruby dependency with ActiveModel::SecurePassword.
* Allow conditional validation of authentication attributes.
* Allow authentication of any model.


## 1.0.7 (4 October 2011)

* Allow more recent bcrypt-ruby versions.


## 1.0.6 (4 October 2011)

* Fix sign-in hook when called outside Quo Vadis.


## 1.0.5 (23 February 2011)

* Support blocking of sign-in process.


## 1.0.4 (22 February 2011)

* Work with Rails' improved CSRF protection.
* Prevent session fixation attacks.


## 1.0.3 (7 February 2011)

* Remember user between browser sessions.


## 1.0.2 (27 January 2011)

* Forgotten-password functionality.


## 1.0.1 (26 January 2011)

* Configurable layout.
* Make flash messages optional.


## 1.0.0 (25 January 2011)

* Sign in.
* Sign out.
* Authenticate actions.
* Remember URL user wants to view.
* Hooks for sign in, sign out, failed sign in.
