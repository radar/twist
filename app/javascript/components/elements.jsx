import React from 'react'
import ReactDOM from 'react-dom'
import ReactCSSTransitionGroup from 'react-addons-css-transition-group'
import uberfetch from 'uberfetch'
import 'whatwg-fetch'

class Elements extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      elements: []
    };
  }

  componentDidMount() {
    uberfetch.get(this.props.elementsURL)
      .then(res => res.json())
      .then(res => {
        this.setState({elements: res.elements});
      });
  }

  render () {
    return (
      <div>
        {this.renderElements()}
      </div>
    )
  }

  renderElements() {
    return this.state.elements.map((element, i) => {
      return <Element
        key={i}
        tag={element.tag}
        elementID={element.id}
        chapterURL={this.props.chapterURL}
        content={element.content} />
    })
  }
}


class Element extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      showThanks: false,
      showForm: false
    };

    this.toggleForm = this.toggleForm.bind(this);
    this.noteSubmitted = this.noteSubmitted.bind(this);
  }

  render () {
    const {elementID, content, tag} = this.props;

    return (
      <div>
        <span className={`note_button note_button_${tag}`} id={`note_button_${elementID}`}>
          <a onClick={this.toggleForm}>+ 0 notes</a>
        </span>
        <div dangerouslySetInnerHTML={{__html: content}}>
        </div>
        {this.renderThanks()}
        {this.renderForm()}
      </div>
    )
  }

  toggleForm() {
    this.setState({showThanks: false, showForm: !this.state.showForm});
  }

  noteSubmitted() {
    this.toggleForm();
    this.setState({showThanks: true})
  }

  renderForm() {
    if (!this.state.showForm) { return }
    const {chapterURL, elementID} = this.props;
    const noteURL = `${chapterURL}/elements/${elementID}/notes`
    return <NoteForm noteSubmitted={this.noteSubmitted} url={noteURL} elementID={this.props.elementID} />
  }

  renderThanks() {
    if (!this.state.showThanks) { return }
    return (
      <div className='thanks show'>Thank you for submitting a note!</div>
    )
  }
}

class NoteForm extends React.Component {
  constructor(props) {
    super(props);

    this.commentChanged = this.commentChanged.bind(this);
    this.submit = this.submit.bind(this);
  }

  commentChanged(e) {
    this.setState({comment: e.target.value});
  }

  submit(event) {
    uberfetch.post(this.props.url, {body: {note: {comment: this.state.comment}}})
      .then(res => {
        if (res.ok) {
          this.props.noteSubmitted();
        }

      })
    event.preventDefault();
  }

  render () {
    const elementID = this.props.elementID
    return (
      <form className="simple_form" onSubmit={this.submit}>
        <p>
          <label htmlFor={`element_${elementID}_note`}>Leave a note (Markdown enabled)</label>
          <textarea className='text required form-control' id={`element_${elementID}_note`} onChange={this.commentChanged}>

          </textarea>
        </p>
        <p>
          <input type="submit" name="commit" value="Leave Note" className="btn btn-primary" />
        </p>
      </form>
    )
  }
}

export default Elements;
