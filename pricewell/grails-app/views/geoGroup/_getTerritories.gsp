<g:select name="geos" from="${territoriesList?.sort {it.name}}" optionKey="id" value="${geoGroupInstance?.geos}"  noSelection="['':'Select Multiple...']" class="required" multiple="true"/>