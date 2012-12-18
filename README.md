facebook-sdk-corona
===================

Modified Facebook SDK - Corona

How To Use:

	1.	Add 'fb.lua' to your project.
	2.	Import this class in the file from which Facebook API needs to be called.
	local fb = require('fb')
  	3.  Methods to be used:

	-- To be called initially before any other method call

	fb:setUpAppId('Enter your app Id here')


	-- To post a message on your wall

	fb:postMessageToFacebook('Enter a message to be posted here')


	-- To post an image on your wall

	fb:postImageOnFacebook( 'Name of the image', 'Link to be opened on image click', 'Link Caption', 'Description to be given with the image', 'Link of an image to be posted', 'Action Name', 'Action Link' )


	-- display a Facebook dialog box for posting to your Wall

	fb:showDialog('Name', 'Description', 'Link')


	-- Sending a request and receiving response
		-- Request: request the current logged in user's info, 'request' can be 'me', 'me/friends', etc. which will return a response in JSON

			fb:getInfo('request')

		-- Response: delegate method ––>> Copy this method in the class where 'fb.lua' has been imported

			function didRecieveResponseWithJSON(response)
				-- Override this method to perform specific tasks needed in your app.
				-- 'response' is a string in JSON format
			end


	-- Log out from facebook

		fb:logOut()