// grails-app/conf/MyFilters.groovy
class StaticFileFilters {
    def filters = {		
        addHeaderforjs(uri: '/*.js') {
            after = {
							response.setHeader('Cache-Control', 'max-age=600')
							response.setDateHeader('Expires', (new Date()+1).time )
            }
        }
        addHeaderforcss(uri: '/*.css') {
            after = {
							response.setHeader('Cache-Control', 'max-age=600')
							response.setDateHeader('Expires', (new Date()+1).time )
            }
        }
        addHeaderforong(uri: '/*.png') {
            after = {
							response.setHeader('Cache-Control', 'max-age=600')
							response.setDateHeader('Expires', (new Date()+1).time )
            }
        }
        addHeaderforgif(uri: '/*.gif') {
            after = {
							response.setHeader('Cache-Control', 'max-age=600')
							response.setDateHeader('Expires', (new Date()+1).time )
            }
        }
    }
}