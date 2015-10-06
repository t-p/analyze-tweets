var Tweet = React.createClass({
  render: function() {
    return (
      <li className="">
        <h4 className="secondary-dark">
          {this.props.tweet.user_name}
        </h4>
        <p>
          {this.props.tweet.text}
        </p>
      </li>
    );
  }
  });

var TweetList = React.createClass({
  render: function() {
    //no "ng-repeat" or "foreach"
    var tweetNodes = this.props.data.map(function(tweet) {
      return (
        <Tweet tweet={tweet} key={tweet.user_name} />
      );
    });

    return (
      <ul className="block-list comment-block">
        {tweetNodes}
      </ul>
    );
  }
});

var Tweets = React.createClass({
  getInitialState: function() {
    //set initial empty dataset
    return {data: []};
  },
  componentDidMount: function() {
    $.ajax({
      url: '/search',
      dataType: 'json',
      success: function(data) {
        //changing state
        this.setState({data: data});
      }.bind(this),
      error: function() {

      }
    });
  },
  render: function() {
    return (
      <TweetList data={this.state.data} />
    );
  }
});

React.render(
  <Tweets />,
  document.getElementById("app-container")
);
