import React from 'react';

const EMOJIES = {
  mad: '😡',
  sad: '😔',
  glad: '🤗'
};

class Likes extends React.PureComponent {
  state = {
    style: 'has-text-info',
    timer: null
  };

  addLike() {
    fetch(`/api/${window.location.pathname}/cards/${this.props.id}/like`, {
      method: 'PUT',
      headers: {
        Accept: 'application/json',
        'Content-Type': 'application/json',
        'X-CSRF-Token': document
          .querySelector("meta[name='csrf-token']")
          .getAttribute('content')
      }
    })
      .then(result => {
        if (result.status !== 200) {
          throw result;
        }
      })
      .catch(error => {
        error.json().then(errorHash => {
          console.log(errorHash.error);
        });
      });
  }

  handleMouseDown = () => {
    this.setState({style: 'has-text-success'});
    this.addLike();
    const timer = setInterval(() => this.addLike(), 300);
    this.setState({timer});
  };

  handleMouseUp = () => {
    this.setState({style: 'has-text-info'});
    clearInterval(this.state.timer);
  };

  handleMouseLeave = () => {
    this.setState({style: 'has-text-info'});
    clearInterval(this.state.timer);
  };

  render() {
    const {type, likes} = this.props;
    const {style} = this.state;

    return (
      <>
        <a
          className={style}
          onMouseDown={this.handleMouseDown}
          onMouseUp={this.handleMouseUp}
          onMouseLeave={this.handleMouseLeave}
        >
          {EMOJIES[type]}
        </a>
        <span> {likes} </span>
      </>
    );
  }
}

export default Likes;
