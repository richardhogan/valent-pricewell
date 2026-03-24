package hr.ngs.templater

/**
 * STUB — the real hr.ngs.templater JAR (commercial product from templater.info) is not present.
 * Replace this stub with the real JAR in pricewell/lib/ when the licensed version is available.
 */
class Configuration {

    static Configuration factory() {
        return new Configuration()
    }

    ITemplateDocument open(InputStream stream, String format, OutputStream output) {
        throw new UnsupportedOperationException(
            "hr.ngs.templater is not available. " +
            "Place the licensed templater.jar in pricewell/lib/ to enable DOCX generation.")
    }
}
