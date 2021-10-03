# Definicao da imagem e diretorio para compilacao/construcao dos fontes da aplicacao:
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /fontes

# Camadas isoladas de copia do *.csproj, para aproveitar recurso de cache de camadas do docker-build, apenas executando dotnet-restore se houverem mudancas:
COPY *.sln .
COPY ConversaoPeso.Web/*.csproj ./ConversaoPeso.Web/
RUN dotnet restore

# Copia dos demais fontes e execucao da compilacao/construcao da aplicacao:
COPY ConversaoPeso.Web/. ./ConversaoPeso.Web/
WORKDIR /fontes/ConversaoPeso.Web
RUN dotnet publish -c release -o /app --no-restore

# Camadas finais, com a imagem e comando de execucao dos fontes compilados:
FROM mcr.microsoft.com/dotnet/aspnet:5.0
WORKDIR /app
COPY --from=build /app ./
EXPOSE 80
ENTRYPOINT ["dotnet", "ConversaoPeso.Web.dll"]
