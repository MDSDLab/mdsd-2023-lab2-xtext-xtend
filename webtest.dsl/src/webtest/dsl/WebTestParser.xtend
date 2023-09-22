package webtest.dsl;

import com.google.inject.Inject
import com.google.inject.Injector
import java.io.IOException
import java.util.ArrayList
import java.util.List
import org.apache.log4j.Logger
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.resource.XtextResource
import org.eclipse.xtext.resource.XtextResourceSet
import org.eclipse.xtext.util.CancelIndicator
import org.eclipse.xtext.util.StringInputStream
import org.eclipse.xtext.validation.CheckMode
import org.eclipse.xtext.validation.IResourceValidator
import org.eclipse.xtext.validation.Issue
import webtest.model.Main
import webtest.model.ModelPackage

class WebTestParser {
    final Logger logger = Logger.getLogger(WebTestParser)

    ModelPackage _soalPackage
    CharSequence _webTestCode
    Injector _injector
    List<Issue> _issues
    boolean _hasAnyErrors
    Issue _firstError
    Main _model

    @Inject
    IResourceValidator _resourceValidator

    @Inject
    XtextResourceSet _resourceSet

    new (CharSequence webTestCode) {
        _soalPackage = ModelPackage.eINSTANCE
        val setup = new WebTestDslStandaloneSetup()
        _injector = setup.createInjectorAndDoEMFRegistration()
        _injector.injectMembers(this);
        _resourceSet = new XtextResourceSet();
        _resourceSet.addLoadOption(XtextResource.OPTION_RESOLVE_ALL, Boolean.TRUE);
        _webTestCode = webTestCode
    }

    def getSoalPackage() { _soalPackage }
    def getResourceSet() { _resourceSet }

    def hasAnyErrors() { 
        if (_issues === null) parseSource()
    	return _hasAnyErrors 
    }

    def getFirstError() { 
        if (_issues === null) parseSource()
    	return _firstError 
    }

    def getIssues() { 
        if (_issues === null) parseSource()
    	return _issues
    }

    def Main getModel() {
        if (_model === null) parseSource()
        return _model;
    }

    private def void parseSource() throws IOException {
    	if (_issues !== null) return;
        val resourceName = "dummy:/source.wt"
        logger.info("Adding resource: "+resourceName)
        val resource = resourceSet.createResource(URI.createURI(resourceName))
        resource.load(new StringInputStream(_webTestCode.toString), resourceSet.getLoadOptions())
        checkResource(resource)
        if (resource.contents !== null && resource.contents.size == 1 && (resource.contents.get(0) instanceof Main)) {
            _model = resource.contents.get(0) as Main;
        }
    }

    def checkResource(Resource resource) {
        val issues = _resourceValidator.validate(resource, CheckMode.ALL, CancelIndicator.NullImpl)
        _issues = new ArrayList<Issue>(issues);
        for (Issue issue : issues) {
            val logEntry = issue.message+" ["+issue.uriToProblem.lastSegment+" ("+issue.lineNumber+","+issue.column+")]"
            switch (issue.severity) {
                case ERROR : {
                    _hasAnyErrors = true
                    _firstError = issue
                    logger.error(logEntry)
                }
                case WARNING : {
                    logger.warn(logEntry);
                }
                case INFO : {
                    logger.info(logEntry);
                }
                default : {
                    logger.trace(logEntry);
                }
            }
        }
    }

}