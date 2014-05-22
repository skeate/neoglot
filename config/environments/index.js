module.exports = function (app, passport) {
	if( app.settings.env == "production" )
		require('./production')(app, passport);
	else
		require('./development')(app, passport);
};
