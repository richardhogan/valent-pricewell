package com.valent.pricewell

import org.apache.shiro.SecurityUtils
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import javax.imageio.ImageIO;
import javax.imageio.stream.ImageInputStream;
import javax.imageio.stream.ImageOutputStream;

import org.springframework.web.multipart.MultipartFile

import grails.converters.JSON

class LogoImageController {

	def fileUploadService
    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

	def beforeInterceptor = [action:this.&debug]
	
	def debug() {
		def user = User.get(new Long(SecurityUtils.subject.principal))
		log.info("[User: ${user.profile.fullName}] - ${actionUri} with params ${params}")
	}
	
    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [logoImageInstanceList: LogoImage.list(params), logoImageInstanceTotal: LogoImage.count()]
    }

    def create = {
        def logoImageInstance = new LogoImage()
        logoImageInstance.properties = params
        return [logoImageInstance: logoImageInstance]
    }

	def renderImage =
	{
		def logoImageInstance = LogoImage.get(params.id)
		if (logoImageInstance?.image)
		{
			response.setContentLength(logoImageInstance.image.length)
			response.outputStream.write(logoImageInstance.image)
		}
		else
		{
			response.sendError(404)
		}
	}
	
	def uploadImage = {
		render(template: "create", model: [logoFor: params.logoFor, source: params.source])
		
		
	}
	
	def showImage =
	{
		def logoImageInstance = LogoImage.get(params.id.toInteger())
		render(template: "showImage", model: [logoImageInstance: logoImageInstance])
	}
	
	def saveLogo = {
		def logoImageInstance = new LogoImage(params)
		def map = new HashMap()
		
		if (logoImageInstance.save(flush: true))
		{
			if(params.id != null)
			{
				def companyInformationInstance = CompanyInformation.get(params.id.toInteger())
				companyInformationInstance.logo = logoImageInstance
				if(companyInformationInstance.save(flush: true))
				{
					redirect(action: "show", id: companyInformationInstance.id)
				}
			}
			
		}
		else {
				render(view: "create", model: [logoImageInstance: logoImageInstance])
		}
	}
	
    def save = {
		def multipartFile = request.getFile('image')
		File imageFile = multipartToFile(multipartFile)
		def filePath = imageFile.getAbsolutePath()
		byte[] imageBytes = convertImageToByteArray(imageFile)
		
		def logoImageInstance = new LogoImage()//(params)
		logoImageInstance.image = imageBytes
		def map = new HashMap()
		if(fileUploadService.isValidImage(imageFile))
		{
			if (logoImageInstance.save(flush: true))
			{
				map["res"] = "success"
				map["id"] = logoImageInstance.id
				map["filePath"] = filePath
				render map as JSON
				
			}
			else {
				map["res"] = "fail"
				render map as JSON
				
			}
		}
		else
		{
			map['res'] = "invalidImage"
			render map as JSON
		}
    }
	
	public File multipartToFile(MultipartFile multipart) throws IllegalStateException, IOException {
		File tmpFile = new File(System.getProperty("java.io.tmpdir") + System.getProperty("file.separator") +
								multipart.getOriginalFilename());
		multipart.transferTo(tmpFile);
		return tmpFile;
	}

	private static byte[] convertImageToByteArray(File file) throws FileNotFoundException, IOException
	{
		InputStream is = new FileInputStream(file );
		long length = file.length();
		// You cannot create an array using a long, it needs to be an int.
		if (length > Integer.MAX_VALUE) {
			System.out.println("File too large!!");
		}
		byte[] bytes = new byte[(int)length];
		int offset = 0;
		int numRead = 0;
		while (offset < bytes.length && (numRead=is.read(bytes, offset, bytes.length-offset)) >= 0) {
			offset += numRead;
		}
		// Ensure all the bytes have been read
		if (offset < bytes.length) {
			System.out.println("Could not completely read file "+file.getName());
		}
		is.close();
		return bytes;
	}
    def show = {
        def logoImageInstance = LogoImage.get(params.id)
        if (!logoImageInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'logoImage.label', default: 'LogoImage'), params.id])}"
            redirect(action: "list")
        }
        else {
            [logoImageInstance: logoImageInstance]
        }
    }

    def edit = {
        def logoImageInstance = LogoImage.get(params.id)
        if (!logoImageInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'logoImage.label', default: 'LogoImage'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [logoImageInstance: logoImageInstance]
        }
    }

    def update = {
        def logoImageInstance = LogoImage.get(params.id)
        if (logoImageInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (logoImageInstance.version > version) {
                    
                    logoImageInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'logoImage.label', default: 'LogoImage')] as Object[], "Another user has updated this LogoImage while you were editing")
                    render(view: "edit", model: [logoImageInstance: logoImageInstance])
                    return
                }
            }
            logoImageInstance.properties = params
            if (!logoImageInstance.hasErrors() && logoImageInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'logoImage.label', default: 'LogoImage'), logoImageInstance.id])}"
                redirect(action: "show", id: logoImageInstance.id)
            }
            else {
                render(view: "edit", model: [logoImageInstance: logoImageInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'logoImage.label', default: 'LogoImage'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def logoImageInstance = LogoImage.get(params.id)
        if (logoImageInstance) {
            try {
                logoImageInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'logoImage.label', default: 'LogoImage'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'logoImage.label', default: 'LogoImage'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'logoImage.label', default: 'LogoImage'), params.id])}"
            redirect(action: "list")
        }
    }
}
