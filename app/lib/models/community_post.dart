class CommunityPost {
  CommunityPost(
      {required this.title,
      required this.author,
      required this.category,
      required this.summary,
      required this.body,
      this.quote});
  final String title;
  final String author;
  final String category;
  final String summary;
  final String body;
  final String? quote;
  bool liked = false;
  bool bookmarked = false;
  bool following = false;
  final comments = <String>[];
}

List<CommunityPost> sampleCommunityPosts() => [
      CommunityPost(
          title: 'Progress Over Perfection',
          author: 'Aaliyah',
          category: 'Stories',
          summary:
              'Some weeks, moving forward means taking one small step. Here are three things that helped me find my footing.',
          quote:
              'You do not have to do it all at once. Small steps move you forward.',
          body:
              'I used to measure a good week by how much I got done. Now I try to notice the moments when I asked for help, made room for rest, or showed up for someone else.\n\n1. Take breaks without guilt\nA pause can give you the space to see what you actually need.\n\n2. Ask for a helping hand\nA small request can open the door to a real connection.\n\n3. Celebrate small wins\nA conversation, a finished task, or getting through a difficult day can be enough. Your progress counts.'),
      CommunityPost(
          title: 'What I Wish I Knew in College',
          author: 'Maya',
          category: 'Stories',
          summary:
              'Five lessons that helped me stay grounded, find my people, and keep going when things got hard.',
          quote:
              'You do not have to do it all at once. Small steps move you forward.',
          body:
              'College can feel overwhelming. The moments that helped me most were often simple: someone checking in, a shared meal, or asking a question I was afraid to ask.\n\n1. Find your people\nLook for people who encourage you, listen to you, and make space for you to be yourself.\n\n2. Ask questions early\nYou do not need to have everything figured out before reaching out.\n\n3. Make time for rest\nA routine that includes rest is easier to return to.\n\n4. Share what you know\nHelping someone else can remind you how much you have learned.\n\n5. Let your path be yours\nYour pace does not need to look like anyone else’s.'),
      CommunityPost(
          title: 'Start with one small act of kindness',
          author: 'Marcus',
          category: 'Tips',
          summary:
              'You do not need a whole free weekend to make a difference. Start with something small and specific.',
          body:
              'Offer to carry a bag, share a skill, or check in with a neighbor. A helpful offer is often most useful when it is clear.\n\nInstead of saying “let me know if you need anything,” try offering a specific task and a time that works for you.\n\nAsk before helping, respect the answer, and choose something you can follow through on.'),
      CommunityPost(
          title: 'A space for community updates',
          author: 'Angel’s Nest',
          category: 'Announcements',
          summary:
              'This sample announcement shows where neighborhood news and community updates can live.',
          body:
              'This is an example announcement for the Community preview. Future updates could include gatherings, new community resources, and opportunities to get involved.\n\nLive announcements, moderation, and public publishing are not connected yet.'),
    ];
