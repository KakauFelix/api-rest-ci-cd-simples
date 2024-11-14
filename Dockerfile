# Etapa 1: Compilação
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app

# Copia o arquivo pom.xml e instala as dependências do Maven
COPY pom.xml .
RUN mvn dependency:go-offline

# Copia todo o código-fonte e realiza o build
COPY src ./src
RUN mvn clean package -DskipTests

# Etapa 2: Imagem final
FROM openjdk:17-jdk-slim
WORKDIR /app

# Copia o JAR gerado na etapa de build
COPY --from=build /app/target/*.jar app.jar

# Define o comando para executar o JAR
ENTRYPOINT ["java", "-jar", "/app.jar"]

# Expõe a porta do Spring Boot (8080 por padrão)
EXPOSE 8080
