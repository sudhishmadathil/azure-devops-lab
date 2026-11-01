namespace DevOpsLab.Web.Services;

public interface IGreetingService
{
    string GetGreeting();
}

public class GreetingService(IConfiguration config) : IGreetingService
{
    public string GetGreeting()
    {
        var message = config["App:Greeting"] ?? "Hello (default)";
        var env = config["ASPNETCORE_ENVIRONMENT"] ?? "unknown";
        return $"{message} | Environment: {env}";
    }
}
