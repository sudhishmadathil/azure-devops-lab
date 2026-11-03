# Stage 1: build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy only the project file first, then restore.
# This layer is cached until package references change.
COPY src/DevOpsLab.Web/DevOpsLab.Web.csproj src/DevOpsLab.Web/
RUN dotnet restore src/DevOpsLab.Web/DevOpsLab.Web.csproj

# Copy the source and publish.
COPY src/ src/
RUN dotnet publish src/DevOpsLab.Web/DevOpsLab.Web.csproj \
    -c Release -o /app/publish --no-restore

# Stage 2: runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .
ENV ASPNETCORE_HTTP_PORTS=8080
EXPOSE 8080

# Run as the non-root user that ships in .NET 8 images.
USER $APP_UID

ENTRYPOINT ["dotnet", "DevOpsLab.Web.dll"]