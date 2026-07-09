package Util;

/**
 * Centralized multi-sport points calculation.
 * Previously this logic lived only inside LeagueServlet and was duplicated
 * (incorrectly, as a football-only formula) inside league.jsp, which meant
 * the standings table showed the wrong points for netball/badminton/etc.
 * Both places should call this one method instead.
 */
public class PointsCalculator {

    private PointsCalculator() {
    }

    public static int calculatePoints(String sportName, int wins, int draws) {
        if (sportName == null || sportName.isBlank()) {
            return (wins * 3) + (draws * 1); // Standard fallback
        }

        String normalized = sportName.trim().toLowerCase();

        if (normalized.contains("football") || normalized.contains("soccer")) {
            // Football: 3 points for a win, 1 point for a draw
            return (wins * 3) + (draws * 1);
        } else if (normalized.contains("netball") || normalized.contains("basketball") || normalized.contains("volleyball")) {
            // Court sports: 2 points for a win, no draws exist
            return (wins * 2);
        } else if (normalized.contains("badminton") || normalized.contains("ping pong") || normalized.contains("tennis")) {
            // Individual racket sports: 1 point per matchup won
            return (wins * 1);
        }

        // System default fallback rule (e.g. 3 for win, 1 for draw)
        return (wins * 3) + (draws * 1);
    }
}