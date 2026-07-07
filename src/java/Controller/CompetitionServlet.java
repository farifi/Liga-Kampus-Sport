package Controller;

import Model.Match;
import DAO.MatchDAO;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "competitionServlet", urlPatterns = {"/admin/competition"})
public class CompetitionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        MatchDAO matchDAO = new MatchDAO();
        List<Match> matchList = matchDAO.selectAllMatches();

        request.setAttribute("matchList", matchList);
        request.getRequestDispatcher("/admin/competitions.jsp").forward(request, response);
    }
}