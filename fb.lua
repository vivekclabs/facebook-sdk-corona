-- 
-- Project: Facebook Connect sample app
--
-- Date: December 24, 2010
--
-- Version: 1.5
--
-- File name: main.lua
--
-- Author: Corona Labs
--
-- Abstract: Presents the Facebook Connect login dialog, and then posts to the user's stream
-- (Also demonstrates the use of external libraries.)
--
-- Demonstrates: webPopup, network, Facebook library
--
-- File dependencies: facebook.lua
--
-- Target devices: Simulator and Device
--
-- Limitations: Requires internet access; no error checking if connection fails
--
-- Update History:
--	v1.1		Layout adapted for Android/iPad/iPhone4
--  v1.2		Modified for new Facebook Connect API (from build #243)
--  v1.3		Added buttons to: Post Message, Post Photo, Show Dialog, Logout
--  v1.4		Added  ...{"publish_stream"} .. permissions setting to facebook.login() calls.
--	v1.5		Added single sign-on support in build.settings (must replace XXXXXXXXX with valid facebook appId)

--
-- Comments:
-- Requires API key and application secret key from Facebook. To begin, log into your Facebook
-- account and add the "Developer" application, from which you can create additional apps.
--
-- IMPORTANT: Please ensure your app is compatible with Facebook Single Sign-On or your
--			  Facebook implementation will fail! See the following blog post for more details:
--			  http://www.coronalabs.com/links/facebook-sso
--
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
-- Modified by Vivek Kaushal, Click Labs Pvt. Ltd on 18 Dec, 2012.
---------------------------------------------------------------------------------------

FB = {}

-- Comment out the next line when through debugging your app.
io.output():setvbuf('no') 		-- **debug: disable output buffering for Xcode Console **tjn

local widget = require("widget")
local facebook = require("facebook")
local json = require("json")

display.setStatusBar( display.HiddenStatusBar )
	
-- Facebook Commands
local fbCommand			-- forward reference
local attachment
local postMsg
local fbURL, req_method, parameters
local nameDialog, descDialog, linkDialog
local LOGOUT = 1
local SHOW_DIALOG = 2
local POST_MSG = 3
local POST_PHOTO = 4
local GET_USER_INFO = 5
local GET_PLATFORM_INFO = 6

-- This function is useful for debugging problems with using FB Connect's web api,
-- e.g. you passed bad parameters to the web api and get a response table back
local function printTable( t, label, level )
	if label then print( label ) end
	level = level or 1

	if t then
		for k,v in pairs( t ) do
			local prefix = ""
			for i=1,level do
				prefix = prefix .. "\t"
			end

			print( prefix .. "[" .. tostring(k) .. "] = " .. tostring(v) )
			if type( v ) == "table" then
				print( prefix .. "{" )
				printTable( v, nil, level + 1 )
				print( prefix .. "}" )
			end
		end
	end
end

-- New Facebook Connection listener
local function listener( event )
	
	
--- Debug Event parameters printout --------------------------------------------------
--- Prints Events received up to 20 characters. Prints "..." and total count if longer
	print( "Facebook Listener events:" )
	
	local maxStr = 20		-- set maximum string length
	local endStr
	
	for k,v in pairs( event ) do
		local valueString = tostring(v)
		if string.len(valueString) > maxStr then
			endStr = " ... #" .. tostring(string.len(valueString)) .. ")"
		else
			endStr = ")"
		end
		print( "   " .. tostring( k ) .. "(" .. tostring( string.sub(valueString, 1, maxStr ) ) .. endStr )
	end
--- End of debug Event routine -------------------------------------------------------

    print( "event.name", event.name ) -- "fbconnect"
    print( "event.type:", event.type ) -- type is either "session" or "request" or "dialog"
	print( "isError: " .. tostring( event.isError ) )
	print( "didComplete: " .. tostring( event.didComplete) )
-----------------------------------------------------------------------------------------
	-- After a successful login event, send the FB command
	-- Note: If the app is already logged in, we will still get a "login" phase
    if ( "session" == event.type ) then
        -- event.phase is one of: "login", "loginFailed", "loginCancelled", "logout"		
		print( "Session Status: " .. event.phase )
		
		if event.phase ~= "login" then
			-- Exit if login error
			return
		end
		
		-- The following displays a Facebook dialog box for posting to your Facebook Wall
		if fbCommand == SHOW_DIALOG then

			-- "feed" is the standard "post status message" dialog
			facebook.showDialog( "feed", {
				name = nameDialog,
				description = descDialog,
				link = linkDialog
			})

			-- for "apprequests", message is required; other options are supported
			--[[
			facebook.showDialog( "apprequests", {
				message = "Example message."
			})
			--]]
		end
	
		-- Request the Platform information (FB information)
		if fbCommand == GET_PLATFORM_INFO then
			facebook.request( "platform" )		-- **tjn Displays info about Facebook platform
		end

		-- Request the current logged in user's info
		if fbCommand == GET_USER_INFO then
			facebook.request( fbURL, req_method, parameters )
			--facebook.request( "me/friends", "GET", attach )		-- Alternate request
		end

		-- This code posts a photo image to your Facebook Wall
		--
		if fbCommand == POST_PHOTO then		
			facebook.request( "me/feed", "POST", attachment )		-- posting the photo
		end
		
		-- This code posts a message to your Facebook Wall
		if fbCommand == POST_MSG then
			facebook.request( "me/feed", "POST", postMsg )	-- posting the message
		end
-----------------------------------------------------------------------------------------

    elseif ( "request" == event.type ) then
        -- event.response is a JSON object from the FB server
        local response = event.response
        
		if ( not event.isError ) then
	        response = json.decode( event.response )
	        
	        if fbCommand == GET_USER_INFO then
				printTable( response, "User Info", 3 )
				didRecieveResponseWithJSON(event.response)
				
			elseif fbCommand == POST_PHOTO then
				printTable( response, "photo", 3 )
							
			elseif fbCommand == POST_MSG then
				printTable( response, "message", 3 )
			else
				-- Unknown command response
				print( "Unknown command response" )
			end
        else
        	-- Post Failed
			printTable( event.response, "Post Failed Response", 3 )
		end
		
	elseif ( "dialog" == event.type ) then
		-- showDialog response
		--
		print( "dialog response:", event.response )
    end
end

---------------------------------------------------------------------------------------------------
-- NOTE: To create a mobile app that interacts with Facebook Connect, first log into Facebook
-- and create a new Facebook application. That will give you the "API key" and "application secret" 
-- that should be used in the following lines:

local appId  = 	""	-- Add  your App ID here (also go into build.settings and replace XXXXXXXXX with your appId under CFBundleURLSchemes)
local apiKey = nil	-- Not needed at this time
---------------------------------------------------------------------------------------------------

-- *************** Functions to be called from another class ***************** --

function FB:setUpAppId(fbAppId)
	appId = fbAppId
end

-- function for posting message on News Feed - Facebook
function FB:postMessageToFacebook(theMessage)
	if (appId) then
		postMsg = {
			message = theMessage
		}
		-- call the login method of the FB session object, passing in a handler
		-- to be called upon successful login.		
		fbCommand = POST_MSG
		facebook.login( appId, listener, {"publish_stream"} )
	else
	end
end

-- function for posting image on facebook
function FB:postImageOnFacebook(theName, theLink, linkCaption, theDescription, pictureLink, actionName, actionLink )
	if (appId) then
		attachment = {
			name = theName,
			link = theLink,
			caption = linkCaption,
			description = theDescription,
			picture = pictureLink,
			actions = json.encode( { { name = actionName, link = actionLink } } )				
		}
		-- call the login method of the FB session object, passing in a handler
		-- to be called upon successful login.
		fbCommand = POST_PHOTO
		facebook.login( appId, listener,  {"publish_stream"}  )
	else
	end
end

function FB:showDialog(name, desc, link)
	-- call the login method of the FB session object, passing in a handler
	-- to be called upon successful login.
	nameDialog = name
	descDialog = desc
	linkDialog = link
	
	fbCommand = SHOW_DIALOG
	facebook.login( appId, listener, {"publish_stream"}  )
end

function FB:getInfo(callUrl, req, params)
	-- call the login method of the FB session object, passing in a handler
	-- to be called upon successful login.
	fbURL = callUrl
	req_method = req
	parameters = params
	fbCommand = GET_USER_INFO
	facebook.login( appId, listener, {"publish_stream"}  )
end

function FB:logOut()
	-- call the login method of the FB session object, passing in a handler
	-- to be called upon successful login.
	fbCommand = LOGOUT
	facebook.logout()
end

return FB