package pricewelldomain



import org.junit.*
import com.valent.pricewell.DocumentTemplate
import grails.test.mixin.*
import com.valent.pricewell.*;

@TestFor(DocumentTemplateController)
@Mock(DocumentTemplate)
class DocumentTemplateControllerTests {


    def populateValidParams(params) {
      assert params != null
      // TODO: Populate valid properties like...
      //params["name"] = 'someValidName'
    }

    void testIndex() {
        controller.index()
        assert "/documentTemplate/list" == response.redirectedUrl
    }

    void testList() {

        def model = controller.list()

        assert model.documentTemplateInstanceList.size() == 0
        assert model.documentTemplateInstanceTotal == 0
    }

    void testCreate() {
       def model = controller.create()

       assert model.documentTemplateInstance != null
    }

    void testSave() {
        controller.save()

        assert model.documentTemplateInstance != null
        assert view == '/documentTemplate/create'

        response.reset()

        populateValidParams(params)
        controller.save()

        assert response.redirectedUrl == '/documentTemplate/show/1'
        assert controller.flash.message != null
        assert DocumentTemplate.count() == 1
    }

    void testShow() {
        controller.show()

        assert flash.message != null
        assert response.redirectedUrl == '/documentTemplate/list'


        populateValidParams(params)
        def documentTemplate = new DocumentTemplate(params)

        assert documentTemplate.save() != null

        params.id = documentTemplate.id

        def model = controller.show()

        assert model.documentTemplateInstance == documentTemplate
    }

    void testEdit() {
        controller.edit()

        assert flash.message != null
        assert response.redirectedUrl == '/documentTemplate/list'


        populateValidParams(params)
        def documentTemplate = new DocumentTemplate(params)

        assert documentTemplate.save() != null

        params.id = documentTemplate.id

        def model = controller.edit()

        assert model.documentTemplateInstance == documentTemplate
    }

    void testUpdate() {
        controller.update()

        assert flash.message != null
        assert response.redirectedUrl == '/documentTemplate/list'

        response.reset()


        populateValidParams(params)
        def documentTemplate = new DocumentTemplate(params)

        assert documentTemplate.save() != null

        // test invalid parameters in update
        params.id = documentTemplate.id
        //TODO: add invalid values to params object

        controller.update()

        assert view == "/documentTemplate/edit"
        assert model.documentTemplateInstance != null

        documentTemplate.clearErrors()

        populateValidParams(params)
        controller.update()

        assert response.redirectedUrl == "/documentTemplate/show/$documentTemplate.id"
        assert flash.message != null

        //test outdated version number
        response.reset()
        documentTemplate.clearErrors()

        populateValidParams(params)
        params.id = documentTemplate.id
        params.version = -1
        controller.update()

        assert view == "/documentTemplate/edit"
        assert model.documentTemplateInstance != null
        assert model.documentTemplateInstance.errors.getFieldError('version')
        assert flash.message != null
    }

    void testDelete() {
        controller.delete()
        assert flash.message != null
        assert response.redirectedUrl == '/documentTemplate/list'

        response.reset()

        populateValidParams(params)
        def documentTemplate = new DocumentTemplate(params)

        assert documentTemplate.save() != null
        assert DocumentTemplate.count() == 1

        params.id = documentTemplate.id

        controller.delete()

        assert DocumentTemplate.count() == 0
        assert DocumentTemplate.get(documentTemplate.id) == null
        assert response.redirectedUrl == '/documentTemplate/list'
    }
}
