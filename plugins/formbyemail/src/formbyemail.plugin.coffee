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
        receivers = []
        enquiry = req.body

        receivers.push(enquiry.email, config.to)
        
        message = util.format('Name: %s\r\n',enquiry.name)
        message += util.format('Email: %s\r\n', enquiry.email)
        message += util.format("Type of patient: %s\r\n", enquiry.Type_of_patient)
        
        message += util.format('Preffered booking: %d/%d/%d at %d:%d\r\n', 
          enquiry.Preferred_Date_DD, 
          enquiry.Preferred_Date_MM , 
          enquiry.Preferred_Date_YYYY , 
          enquiry.Preferred_Time_HH , 
          enquiry.Preferred_Time_MM , 
        )
        
        message += util.format('Message: %s',enquiry.message) 
          
        console.log(message);

        mailOptions = {
          to: receivers.join(","),
          from: config.from or enquiry.email,
          subject: 'Appointment request ' + enquiry.name + ' <' + enquiry.email + '>',
          text: message,
        }

        smtp.sendMail mailOptions, (err, resp) ->
          if(err)
            console.log err
          else
            console.log("Message sent: " + resp.message);

        res.redirect enquiry.redirect or config.redirect

      @
