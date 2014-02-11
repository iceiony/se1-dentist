nodemailer = require 'nodemailer'
util = require 'util'

module.exports = (BasePlugin) ->

  class ContactifyPlugin extends BasePlugin
    name: 'formbyemail'

    config = docpad.getConfig().plugins.contactify
    smtp = nodemailer.createTransport('SMTP', config.transport)

    serverExtend: (opts) ->
      {server} = opts

      server.post config.path, (req, res) ->
        receivers = config.to
        enquiry = req.body
        
        message =  util.format('Name                 %s\r\n',enquiry.name)
        message += util.format('Email                 %s\r\n', enquiry.email)
        message += util.format('Phone                %s\r\n', enquiry.phone)
        message += util.format("Type of patient     %s\r\n", enquiry.type_of_patient)
        message += util.format('Preffered time      %s\r\n', enquiry.preferred_time)
        message += util.format('\r\nMessage:\r\n\t%s',enquiry.message) 
          
        mailOptions = {
          to: receivers.join(","),
          from: enquiry.email or "info@se1-dentist.co.uk",
          subject: 'Appointment request ' + enquiry.name + ' <' + enquiry.email + '>',
          text: message,
        }

        smtp.sendMail mailOptions, (err, resp) ->
          if(err)
            console.log err
            console.log("Message failed: " + message );
          else
            console.log("Message sent: " + resp.message);

        res.redirect enquiry.redirect or config.redirect

      @
