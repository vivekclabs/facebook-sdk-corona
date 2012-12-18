{\rtf1\ansi\ansicpg1252\cocoartf1187
{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\listtable{\list\listtemplateid1\listhybrid{\listlevel\levelnfc0\levelnfcn0\leveljc0\leveljcn0\levelfollow0\levelstartat1\levelspace360\levelindent0{\*\levelmarker \{decimal\}.}{\leveltext\leveltemplateid1\'02\'00.;}{\levelnumbers\'01;}\fi-360\li720\lin720 }{\listname ;}\listid1}}
{\*\listoverridetable{\listoverride\listid1\listoverridecount0\ls1}}
\margl1440\margr1440\vieww12600\viewh7800\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural

\f0\fs24 \cf0 facebook-sdk-corona\
===================\
\
Modified Facebook SDK - Corona\
\

\b\fs28 How To Use:
\b0\fs24 \
\
\pard\tx220\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\li720\fi-720\pardirnatural
\ls1\ilvl0\cf0 {\listtext	1.	}Add 'fb.lua' to your project.\
{\listtext	2.	}Import this class in the file from which Facebook API needs to be called.\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural
\cf0 	
\i local fb = require('fb')
\i0 \
   3.     Methods to be used:\
\
	-- To be called initially before any other method call\
\

\i 	fb:setUpAppId('Enter your app Id here')
\i0 \
\
\
	-- To post a message on your wall\
\

\i 	fb:postMessageToFacebook('Enter a message to be posted here')
\i0 \
\
\
	-- To post an image on your wall\
\

\i 	fb:postImageOnFacebook( 'Name of the image', 'Link to be opened on image click', 'Link Caption', 'Description to be given with the image', 'Link of an image to be posted', 'Action Name', 'Action Link' )
\i0 \
\
\
	-- display a Facebook dialog box for posting to your Wall\
\

\i 	fb:showDialog('Name', 'Description', 'Link')
\i0 \
\
\
	
\b -- Sending a request and receiving response
\b0 \
		-- Request: request the current logged in user's info, 'request' can be 'me', 'me/friends', etc. which will return a response in JSON\
\

\i 			fb:getInfo('request')
\i0 \
\
		-- Response: delegate method \'96\'96>> Copy this method in the class where 'fb.lua' has been imported\
\

\i 			function didRecieveResponseWithJSON(response)\
				-- Override this method to perform specific tasks needed in your app.\
				-- 'response' is a string in JSON format\
			end
\i0 \
\
\
	-- Log out from facebook\
\

\i 		fb:logOut()}