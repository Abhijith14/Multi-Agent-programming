package jason.eis;
import java.awt.Point;
import eis.AgentListener;
import eis.EnvironmentInterfaceStandard;
import eis.EnvironmentListener;
import eis.exceptions.*;
import eis.iilang.*;
import jason.JasonException;
import jason.NoValueException;
import jason.asSyntax.*;
import jason.environment.Environment;
import massim.eismassim.EnvironmentInterface;

import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;


/**
 * This class functions as a Jason environment, using EISMASSim to connect to a MASSim server.
 * (see http://cig.in.tu-clausthal.de/eis)
 * (see also https://multiagentcontest.org)
 *
 * @author Jomi
 * - adapted by ta10
 */
public class EISAdapter extends Environment implements AgentListener {

    private Logger logger = Logger.getLogger("EISAdapter." + EISAdapter.class.getName());

    Point P1 = new Point(0,0);
    Boolean stepDone = false;
    int oldStep = 0;
    
    int stepC = 0;
    int newstepC = 0;

    private EnvironmentInterfaceStandard ei;

    public EISAdapter() {
        super(20);
    }

    @Override
    public void init(String[] args) {

        ei = new EnvironmentInterface("conf/eismassimconfig.json");

        try {
            ei.start();
        } catch (ManagementException e) {
            e.printStackTrace();
        }

        ei.attachEnvironmentListener(new EnvironmentListener() {
                public void handleNewEntity(String entity) {}
                public void handleStateChange(EnvironmentState s) {
                    logger.info("new state "+s);
                }
                public void handleDeletedEntity(String arg0, Collection<String> arg1) {}
                public void handleFreeEntity(String arg0, Collection<String> arg1) {}
        });

        for(String e: ei.getEntities()) {
            System.out.println("Register agent " + e);

            try {
                ei.registerAgent(e);
            } catch (AgentException e1) {
                e1.printStackTrace();
            }

            ei.attachAgentListener(e, this);

            try {
                ei.associateEntity(e, e);
            } catch (RelationException e1) {
                e1.printStackTrace();
            }
        }
    }

    @Override
    public void handlePercept(String agent, Percept percept) {}

    @Override
    public List<Literal> getPercepts(String agName) {

        Collection<Literal> ps = super.getPercepts(agName);
        List<Literal> percepts = ps == null? new ArrayList<>() : new ArrayList<>(ps);

        String lastAction = "";
        String lastActionParams = "";
        String lastActionResult = "";
        int NewStep = 0;


        clearPercepts(agName);

        if (ei != null) {
            try {

                Map<String,Collection<Percept>> perMap = ei.getAllPercepts(agName);
                for (String entity: perMap.keySet()) {
                    Structure strcEnt = ASSyntax.createStructure("entity", ASSyntax.createAtom(entity));
                    for (Percept p: perMap.get(entity)) {
                        try {

                            if(p.getName().equals("lastAction")) {
                                lastAction = p.getParameters().get(0).toString();
                                if (agName.toString().equals("connectionA5")){
                                    System.out.println("Last Action for agent 5: " + lastAction);
                                }
                            }

                            if(p.getName().equals("lastActionParams")) {
                                lastActionParams = p.getParameters().get(0).toString();
                                lastActionParams = lastActionParams.substring(1, lastActionParams.length()-1);
                            }

                            if(p.getName().equals("lastActionResult")) {
                                lastActionResult = p.getParameters().get(0).toString();
                            }

                            if(p.getName().equals("step")) {

                                //System.out.println("Step: " + p.getParameters().get(0).toString());
                                //stepDone = true;
                                //stepC = stepC + 1;

                                NewStep = Integer.parseInt(p.getParameters().get(0).toString());
                            }


                            
                            //System.out.println("Last Action: " + lastAction);
                          //  System.out.println("Last Action Result: " + lastActionResult);

                            

                          //  System.out.println("Agent: " + agName.toString() + " At " + P1.toString());
                            
                            //create a new percept that updates agents position
                           // Point P1 = new Point(X, Y);
                           
                            
                            percepts.add(perceptToLiteral(p).addAnnots(strcEnt));


                         //  System.out.println(percepts);


                        } catch (JasonException e) {
                            e.printStackTrace();
                        }
                    }
                }
            } catch (PerceiveException e) {
                logger.log(Level.WARNING, "Could not perceive.");
            }
        }


        if (NewStep > oldStep){
            stepC = stepC + 1;
            oldStep = NewStep;
           // System.out.println("A STEP COMPLETED with last action : " + lastAction + "-" + lastActionParams + "-" + lastActionResult);

            if (lastAction.equals("move") && lastActionResult.equals("success")){
                System.out.println("MOVING !!!!");
                switch(lastActionParams){
                    case "n":
                        P1.y = P1.y - 1;
                        break;
                    case "s":
                        System.out.println("MOVINFFDFF SOUTH !!!!");
                        P1.y = P1.y + 1;
                        System.out.println("Latest Position: " + P1.toString());
                        break;
                    case "e":
                        P1.x = P1.x + 1;
                        break;
                    case "w":
                        P1.x = P1.x - 1;
                        break;
                }
            }  


        }

        Literal position = ASSyntax.createLiteral("position", 
        ASSyntax.createNumber(P1.getX()), 
        ASSyntax.createNumber(P1.getY()));
        
        percepts.add(position);
       
       // System.out.println("STEPS: " +Integer.toString(NewStep));
        //System.out.println("NSTEP:OSTEP " + Integer.toString(NewStep) +":"+ Integer.toString(oldStep) + " COUNT: " + Integer.toString(stepC) + " AGENT: " + agName.toString() + " STEP DONE: " + Boolean.toString(stepDone));


        
        

        return percepts;
    }

    @Override
    public boolean executeAction(String agName, Structure action) {

        if (ei == null) {
            logger.warning("There is no environment loaded! Ignoring action " + action);
            return false;
        }

        try {
            ei.performAction(agName, literalToAction(action));
            return true;
        } catch (ActException e) {
            e.printStackTrace();
        }

        return false;
    }

    /** Called before the end of MAS execution */
    @Override
    public void stop() {
        if (ei != null) {
            try {
                if (ei.isKillSupported()) ei.kill();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        super.stop();
    }

    private static Literal perceptToLiteral(Percept per) throws JasonException {
        Literal l = ASSyntax.createLiteral(per.getName());
        for (Parameter par: per.getParameters())
            l.addTerm(parameterToTerm(par));
        return l;
    }

    private static Term parameterToTerm(Parameter par) throws JasonException {
        if (par instanceof Numeral) {
            return ASSyntax.createNumber(((Numeral)par).getValue().doubleValue());
        } else if (par instanceof Identifier) {
            try {
                Identifier i = (Identifier)par;
                String a = i.getValue();
                if (!Character.isUpperCase(a.charAt(0)))
                    return ASSyntax.parseTerm(a);
            } catch (Exception ignored) {}
            return ASSyntax.createString(((Identifier)par).getValue());
        } else if (par instanceof ParameterList) {
            ListTerm list = new ListTermImpl();
            ListTerm tail = list;
            for (Parameter p: (ParameterList)par)
                tail = tail.append( parameterToTerm(p) );
            return list;
        } else if (par instanceof Function) {
            Function f = (Function)par;
            Structure l = ASSyntax.createStructure(f.getName());
            for (Parameter p: f.getParameters())
                l.addTerm(parameterToTerm(p));
            return l;
        }
        throw new JasonException("The type of parameter "+par+" is unknown!");
    }

    private static Action literalToAction(Literal action) {
        Parameter[] pars = new Parameter[action.getArity()];
        for (int i = 0; i < action.getArity(); i++)
            pars[i] = termToParameter(action.getTerm(i));
        return new Action(action.getFunctor(), pars);
    }

    private static Parameter termToParameter(Term t) {
        if (t.isNumeric()) {
            try {
                double d = ((NumberTerm) t).solve();
                if((d == Math.floor(d)) && !Double.isInfinite(d)) return new Numeral((int)d);
                return new Numeral(d);
            } catch(NoValueException e){
                e.printStackTrace();
            }
            return new Numeral(null);
        } else if (t.isList()) {
            Collection<Parameter> terms = new ArrayList<>();
            for (Term listTerm: (ListTerm)t)
                terms.add(termToParameter(listTerm));
            return new ParameterList( terms );
        } else if (t.isString()) {
            return new Identifier( ((StringTerm)t).getString() );
        } else if (t.isLiteral()) {
            Literal l = (Literal)t;
            if (!l.hasTerm()) {
                return new Identifier(l.getFunctor());
            } else {
                Parameter[] terms = new Parameter[l.getArity()];
                for (int i = 0; i < l.getArity(); i++)
                    terms[i] = termToParameter(l.getTerm(i));
                return new Function( l.getFunctor(), terms );
            }
        }
        return new Identifier(t.toString());
    }
}