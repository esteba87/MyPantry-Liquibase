package it.mypantry.liquibase.filters;

import liquibase.changelog.IncludeAllFilter;

/**
 * Filtro personalizzato di Liquibase che include solo i file con estensione .xml.
 *
 * Utilizzato nel changelog master tramite:
 * <includeAll path="sql-scripts/releases" filter="it.mypantry.liquibase.filters.XmlFilesFilter"/>
 */
public class XmlFilesFilter implements IncludeAllFilter {
    @Override
    public boolean include(String changeLogPath) {
        return !changeLogPath.contains(".bak.");
    }
}