# Dockerfile.liquibase

##########################################
# FASE 1: BUILDER (Compilazione Maven)
##########################################
# Usiamo un'immagine con Java e Maven
FROM maven:3.9.5-eclipse-temurin-17 AS builder

# Imposta la directory di lavoro
WORKDIR /app

# Copia i file di configurazione Maven e il codice del filtro
# Assicurati che il codice del filtro sia nella stessa cartella dove esegui il docker build
COPY pom.xml .
COPY src ./src

# Esegui la compilazione Maven per creare il JAR
# Usa 'mvn clean install' o 'mvn clean package'
RUN mvn clean install -DskipTests

##########################################
# FASE 2: IMMAGINE FINALE (Esecuzione Liquibase)
##########################################
# Partiamo dall'immagine ufficiale Liquibase
FROM liquibase/liquibase:latest

# Crea la cartella per i plugin
RUN mkdir -p /liquibase/lib

# Determina il percorso del JAR compilato
# Esempio: /app/target/liquibase-filter-1.0.0.jar
# (Modifica il nome del JAR in base al tuo pom.xml)
ARG JAR_FILENAME=liquibase-filter.jar

# COPIA: Copia il JAR compilato dalla fase 'builder' all'immagine finale
COPY --from=builder /app/target/*.jar /liquibase/lib/${JAR_FILENAME}

# Imposta le variabili d'ambiente Liquibase (opzionale, ma utile)
ENV LIQUIBASE_CLASSPATH="/liquibase/lib/"${JAR_FILENAME}

# Il resto dell'immagine è pronto