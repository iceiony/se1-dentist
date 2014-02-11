# The DocPad Configuration File
# It is simply a CoffeeScript Object which is parsed by CSON
docpadConfig = {
    # =================================
    # Template Data
    # These are variables that will be accessible via our templates
    # To access one of these within our templates, refer to the FAQ: https://github.com/bevry/docpad/wiki/FAQ

    templateData:

        # Specify some site properties
        site:
            # The production url of our website
            url: "http://www.se1-dentist.co.uk/"

            # Here are some old site urls that you would like to redirect from
            oldUrls: [
                'www.website.com',
                'website.herokuapp.com'
            ]

            # The default title of our website
            title: "SE1 Dentist"

            # The website description (for SEO)
            description: """
                Private and General Dental care at NHS prices in Old Kent Road. Your New London SE1 dentist in Southwark.
                """

            # The website keywords (for SEO) separated by commas
            keywords: """
                dentist, dentistry, london se1, nhs dentist, private, general, emergency, old kent road
                """

            # The website's styles
            styles: [
                '/vendor/normalize.css'
                '/vendor/h5bp.css'
                '/css/global.css'
            ]

            # The website's scripts
            scripts: [
                '/vendor/log.js'
                '/vendor/modernizr.js'
                '/js/ga.js'
                '/js/email.js'
                '/js/AC_RunActiveContent.js'
            ]


        # -----------------------------
        # Helper Functions

        # Get the prepared site/document title
        # Often we would like to specify particular formatting to our page's title
        # we can apply that formatting here
        getPreparedTitle: ->
            # if we have a document title, then we should use that and suffix the site's title onto it
            if @document.title
                "#{@document.title} | #{@site.title}"
            # if our document does not have it's own title, then we should just use the site's title
            else
                @site.title

        # Get the prepared site/document description
        getPreparedDescription: ->
            # if we have a document description, then we should use that, otherwise use the site's description
            @document.description or @site.description

        # Get the prepared site/document keywords
        getPreparedKeywords: ->
            # Merge the document keywords with the site keywords
            @site.keywords.concat(@document.keywords or []).join(', ')

    #========================
    #DocPad Plugins   
    #
    # configure the different plugins of your webstite 
    plugins:
        contactify:
            path: '/book'
            transport: {
                service: 'Gmail',
                auth: {
                    user: 'someone@gmail.com',
                    pass: ''
                }
            }
            redirect: '/'
            to: 'someone@gmail.com'      
            
        redirector:
            redirects:
                "index.php":"index.html"
                "booking.php":"booking"
                "about_us.php":"about-us"
                "nhs_private_dentistry.php":"nhs-private-dentistry"
                "free_guide.php":"fee-guide"
                "genera_dental_care.php":"general-dental-care"
                "special_offers.php":"special-offers"
                "contact_us.php":"contact-us"
                "white_fillings.php":"white-fillings"
                "teeth_whitening.php":"teeth-whitening"
                "all_ceramic_crowns_%20bridges.php":"all-ceramic-crowns-bridges"
                "veneers.php":"veneers"
                "inlays_onlays.php":"inlays-onlays"
                "dentures.php":"dentures"
                "Tour_of_our_Practice.php":"tour-of-our-practice"
                "cosmetic_dentistry.php": "cosmetic-dentistry"
            
    # =================================
    # DocPad Events
    
    # Here we can define handlers for events that DocPad fires
    # You can find a full listing of events on the DocPad Wiki
    events:

        # Server Extend
        # Used to add our own custom routes to the server before the docpad routes are added
        serverExtend: (opts) ->
            # Extract the server from the options
            {server} = opts
            docpad = @docpad

            # As we are now running in an event,
            # ensure we are using the latest copy of the docpad configuraiton
            # and fetch our urls from it
            latestConfig = docpad.getConfig()
            oldUrls = latestConfig.templateData.site.oldUrls or []
            newUrl = latestConfig.templateData.site.url

            # Redirect any requests accessing one of our sites oldUrls to the new site url
            server.use (req,res,next) ->
                if req.headers.host in oldUrls
                    res.redirect(newUrl+req.url, 301)
                else
                    next()
}

# Export our DocPad Configuration
module.exports = docpadConfig