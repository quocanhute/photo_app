import { Controller } from "@hotwired/stimulus"
import "choices"

// Connects to data-controller="search"
export default class extends Controller {
  static targets = ["input", "suggestions","list_tags"];

  connect() {
    this.hideSuggestions();
    document.addEventListener("click", (event) => {
      if (!this.element.contains(event.target)) {
        this.hideSuggestions();
      }
    });

    const select = new Choices(this.list_tagsTarget, {
      removeItemButton: true,
      maxItemCount:5,
      searchResultLimit:5,
      renderChoiceLimit:5
    });
  }

  suggestions() {
    const selectedTagIds = Array.from(this.list_tagsTarget.selectedOptions).map(option => option.value);// Get an array of selected values

    // Handle change event on the select
    const query = this.inputTarget.value;
    const url = this.element.dataset.suggestionsUrl;
    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => {
      this.requestSuggestions(query,selectedTagIds, url);
    }, 250);
  }

  requestSuggestions(query,selectedTagIds, url) {
    if (query.length === 0) {
      this.hideSuggestions();
      return;
    }
    this.showSuggestions();

    fetch(url, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']")
            .content,
      },
      body: JSON.stringify({ query: query, tag_ids: selectedTagIds }),
    }).then((response) => {
      response.text().then((html) => {
        document.body.insertAdjacentHTML("beforeend", html);
      });
    });
  }

  childClicked(event) {
    this.childWasClicked = this.element.contains(event.target);
  }

  showSuggestions() {
    this.suggestionsTarget.classList.remove("d-none");
  }

  hideSuggestions() {
    if (!this.childWasClicked) {
      this.suggestionsTarget.classList.add("d-none");
    }
    this.childWasClicked = false;
  }
}