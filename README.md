**SoveItApp!**

![app's logo](https://github.com/salvatore373/solveitapp/raw/main/presentation/name%20and%20logo.png)

[Open Website](https://salvatore373.github.io/solveitapp/)

**Introduction**

SolveItApp is an application that allows its users community to share problems and find solutions. All the problems are organized in themes, structured in a map. Real-life problems are often related to multiple themes, so the map allows you to easily see how different sectors can be strictly connected, and in which way.

Anyone can open a problem in a certain category, and anyone can propose a solution. Discussion with people dealing with the same problem will expand your knowledge of the context, give you a different perspective and help to find a new solution. Furthermore you can fund a newborn and promising solution, or review one that you are trying.

Collaborate with the community and make the world a better place!

**MapsMap challenge**

Over the past weeks I developed a cross-platform app, even if some features have not been implemented yet due to time reasons. In the following paragraphs I provide a detailed explanation of my idea of the project and how to realize it, paying particular attention to the features that I had no time to develop, and the ones that could be added in further stages of the project.

**Data representation**

All the classes that take part in the app are represented in the following UML-like diagram (the types used in the diagram are the Dart types):

![UML scheme](https://github.com/salvatore373/solveitapp/raw/main/presentation/uml-scheme.jpg)

The app communicates with 2 databases:

- A Neo4j database to store the themes graph:

Since the themes will be displayed as a tree, it is useful to store their relationships in a graph database.

- A NoSQL database (e.g. Amazon DynamoDB) with 6 tables:  to store the data about problems (and descr), solutions (and descr), reviews and users:
  - *Problem*s table, with the data about each problem (as shown in the UML diagram) structured like:
```
"problems": {
    "probleUID": {
      "title": "String",
      "descriptionId": "String",
      "authorId": "String",
      "categoriesId": ["String"],
      "imagesLink": ["String"],
      "solutionsId": ["String"]
    }
}
```

- *Solution*s table, with the data about each solution (as shown in the UML diagram) structured like:
```
"solutions": {
    "UID": {
      "title": "String",
      "descriptionId": "String",
      "originalProblemId": "String",
      "authorId": "String",
      "extendedProblemsId": ["String"],
      "reviewsId": ["String"],
      "developmentFlowSteps": ["String"]
    }
}
```

- *Problems descriptions*, that stores the content of the description field of each problem, and is structured like this:
```
"descriptions": {
       "UID": "String"
}
```

- *Solutions descriptions*, that stores the content of the description field of each solution, and is structured like this:
```
"descriptions": {
       "UID": "String"
}
```

- *Theme*s table, with the data about the themes in the graph (as shown in the UML diagram) structured like:
```
"themes": {
    "UID": {
      "graphNodeId": "String",
      "title": "String"
    }
}
```

- *Review*s, that stores the reviews to the solutions, and is structured like this:
```
"reviews": {
    "String": {
      "userId": "String",
      "title": "String",
      "text": "String",
      "stars": int
    }
  }
```

- *User*s, that stores the problems opened, the solutions proposed and the reviews of a user, and each node is bijectively associated with a user ID in the authentication database, and is structured like this:
```
"users": {
    "UID": { // This UID is the same associated to the same user in the auth database
      "firstName": "String",
      "lastName": "String",
      "problemsIds": ["String"],
      "solutionsIds": ["String"]
    }
  }
```

The separation between the Problems and their description (and analogously for the Solutions) is meant to allow a faster (and more efficient) access to the problems' nodes, as sometimes the description isn't needed when retrieving a problem, but it can be very long and, then, very expensive in terms of performances.


**User authentication**

Authentication is not needed to access the app: anybody is able to look at the themes map and all the problems and solutions, without identifying. Users must authenticate only when they want to open a problem, propose or review a solution or propose a change to a problem or solution page.

When the app's user is authenticated, they can also access their "**user page**", showing the opened problems, the proposed solutions and their reviews. Furthermore, it contains the fundamental features to edit the profile data (e.g name, email, password...).

I would have implemented user authentication using the Amazon Cognito service.

[add user page screenshot on the side]


**Problem Page**

![problem route](https://github.com/salvatore373/solveitapp/raw/main/presentation/screenshots/problem-route.png)

To open a problem you must specify:

- the *name* you choose for the problem
- a *description* of the problem, that provides the community with the information needed to find a solution
- all the *themes* related to your problem, that represent the context

Optionally you can also provide:

- some images that describe the problem (the main one will be shown as a cover in the problem's page, and clicking on it the gallery will pop up)

The problem page also contains the "*Join Discussion*" button, to get on the Discord/Slack discussion dedicated to the problem, where people can confront, share their ideas and experiences on the field in order to find together a solution.

All the solutions suitable to the problem (as selected by the problem creator, suggested by the other users) are shown under the "*Solutions*" section.

Furthermore, there is a "*Look for solutions*" button, that is the implementation on the problem side of the "*Extend solution*" feature, that will be later discussed.

Even if this feature has not been implemented yet in the app, clicking on the "pencil" icon in the top-right corner, any user can propose a change to the problem's page, and the community can approve or discard it, in a Wikipedia-like manner. This is a very complicated feature, and has not been fully implemented because it would have required too much time, and for this reason I suggest to deliver this functionality in a further stage of the project, in the following versions of the app.


**Solution Page**
![sol-route1](https://github.com/salvatore373/solveitapp/raw/main/presentation/screenshots/solution-route1.png)        **![sol-route2](https://github.com/salvatore373/solveitapp/raw/main/presentation/screenshots/solution-route2.png)**

To propose a solution for a problem you must specify:

- the *name* of your solution,
- a *description* of your solution.

Optionally you can provide a *"Development Flow*", namely all the phases/milestones that have to be fulfilled to complete the development process of the solution.

The solution page contains a "*Join the discussion*" button that works as the same button in the problem page, and lets the community discuss to improve the solution. All the users that adopted a solution can share their thoughts by writing a review.

If a solution needs to be economically funded, the proposer can add a Kickstarter link to start a crowdfunding campaign. For this purpose I suggest not to create a new Kickstarter-like service, but to use the original Kickstarter, since it is very difficult to design, develop and manage a service like that, and the Kickstarter team would have much more knowledge and experience in this field.

Furthermore, there is the "*Applied to*" category, that shows all the problems that this solution has been applied to, and an "*Extend Solution*" button, that is the implementation on the solution side of the "*Extend solution*" feature, that will be discussed in the next paragraph.

The "pencil" icon in the top-right corner works exactly as the same icon in the problems page, but it's used to propose a change to the solution's page.


**Extend Solution feature**

Sometimes people have very similar problems and the same solution (maybe with little variations) can be used by all of them, while very often the solution to your problem already exists. This is where the "*Extend Feature*" of the SolveItApp! comes in. For each problem the software suggests the solutions that have been applied to problems associated with similar themes, and each user can suggest to extend a specific solution to a problem, so that the problem's creator (or, possibly, the community) can decide to adopt that solution to another problem.


**Fork feature**

It is easier to develop new solutions working on an existing one instead of creating it from scratch, and sometimes problems are very similar. The fork feature, which should be delivered in the future versions of the app, has the purpose to create a copy of a problem or solution that can be fully edited to be adapted to a new situation. This should work as Github's fork feature, with little changes to prevent problem and solution duplicates.


**Home Page**

![maproute](https://github.com/salvatore373/solveitapp/blob/main/presentation/screenshots/map-route.png)

The home page shows the themes map.

As described in the introduction, the problems are organized in themes, and the themes are structured in a map. The map has a root node, and anyone can connect a macro-theme to it or add a branch to an existing theme. Each theme can have a description and can contain problems (however, it is highly recommended to put problems in specific themes and not in macro-themes). A problem can be connected to many themes, and each theme can show a list of all the problems related to it. To add a problem or edit a theme, all you have to do is tap on its button on the map.

As the application scales, many problems and themes will be added to the map, and it could become overwhelming to access the app's content just by navigating the map. For this reason the home page also contains a search bar at the top, that allows you to search for a specific theme or problem by its name. (The search feature has not been implemented yet due to time reasons)

**GeoProblemMap feature**

Besides the themes map, problems can also be found on a real map, where you can see all the problems related to a specific location. This feature should be delivered in the future versions of the app, and should allow users to better understand what are the major problems that affect their region and how the local community can collaborate to solve them. As users deal with problems that are very close to them, they feel closer to the SolveItApp! community and to the app itself, resulting in a better engagement.


**Development framework and platforms**

This app has been developed by myself (Salvatore Michele Rago) in Dart using Flutter. Flutter is Google's framework to build cross-platform applications from the same codebase.

I decided to use Flutter so that the whole application can be built (and eventually maintained) by a single team, and it is immediately available for Android, iOS and web.

- **Internationalization** 

The app currently supports only English, but Flutter allows a very simple and fast internationalization process that can be completed in a very short time. Furthermore, since I am Italian, I could deal with the Italian translation.

- **Mock data**

The application is filled with mock data just to show to the challenge commission how it would work with an active community. However, the code is designed to be easily connected to the databases and display real data.

- **Domain**

Even if the app has been developed under the com.solveitapp domain, I'm not the owner, and it will be buyed if the judges decide to use this app and this name.

