#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["BankWebapp1/BankWebapp1.csproj", "BankWebapp1/"]
RUN dotnet restore "BankWebapp1/BankWebapp1.csproj"
COPY . .
WORKDIR "/src/BankWebapp1"
RUN dotnet build "BankWebapp1.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "BankWebapp1.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "BankWebapp1.dll"]