package com.valent.pricewell

import org.springframework.dao.DataIntegrityViolationException

class FieldMappingController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    }

    def list() {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [fieldMappingInstanceList: FieldMapping.list(params), fieldMappingInstanceTotal: FieldMapping.count()]
    }

    def create() {
        [fieldMappingInstance: new FieldMapping(params)]
    }

    def save() {
        def fieldMappingInstance = new FieldMapping(params)
        if (!fieldMappingInstance.save(flush: true)) {
            render(view: "create", model: [fieldMappingInstance: fieldMappingInstance])
            return
        }

		flash.message = message(code: 'default.created.message', args: [message(code: 'fieldMapping.label', default: 'FieldMapping'), fieldMappingInstance.id])
        redirect(action: "show", id: fieldMappingInstance.id)
    }

    def show() {
        def fieldMappingInstance = FieldMapping.get(params.id)
        if (!fieldMappingInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'fieldMapping.label', default: 'FieldMapping'), params.id])
            redirect(action: "list")
            return
        }

        [fieldMappingInstance: fieldMappingInstance]
    }

    def edit() {
        def fieldMappingInstance = FieldMapping.get(params.id)
        if (!fieldMappingInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'fieldMapping.label', default: 'FieldMapping'), params.id])
            redirect(action: "list")
            return
        }

        [fieldMappingInstance: fieldMappingInstance]
    }

    def update() {
        def fieldMappingInstance = FieldMapping.get(params.id)
        if (!fieldMappingInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'fieldMapping.label', default: 'FieldMapping'), params.id])
            redirect(action: "list")
            return
        }

        if (params.version) {
            def version = params.version.toLong()
            if (fieldMappingInstance.version > version) {
                fieldMappingInstance.errors.rejectValue("version", "default.optimistic.locking.failure",
                          [message(code: 'fieldMapping.label', default: 'FieldMapping')] as Object[],
                          "Another user has updated this FieldMapping while you were editing")
                render(view: "edit", model: [fieldMappingInstance: fieldMappingInstance])
                return
            }
        }

        fieldMappingInstance.properties = params

        if (!fieldMappingInstance.save(flush: true)) {
            render(view: "edit", model: [fieldMappingInstance: fieldMappingInstance])
            return
        }

		flash.message = message(code: 'default.updated.message', args: [message(code: 'fieldMapping.label', default: 'FieldMapping'), fieldMappingInstance.id])
        redirect(action: "show", id: fieldMappingInstance.id)
    }

    def delete() {
        def fieldMappingInstance = FieldMapping.get(params.id)
        if (!fieldMappingInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'fieldMapping.label', default: 'FieldMapping'), params.id])
            redirect(action: "list")
            return
        }

        try {
            fieldMappingInstance.delete(flush: true)
			flash.message = message(code: 'default.deleted.message', args: [message(code: 'fieldMapping.label', default: 'FieldMapping'), params.id])
            redirect(action: "list")
        }
        catch (DataIntegrityViolationException e) {
			flash.message = message(code: 'default.not.deleted.message', args: [message(code: 'fieldMapping.label', default: 'FieldMapping'), params.id])
            redirect(action: "show", id: params.id)
        }
    }
}
