import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    greet() {
        const $navbarBurgers = Array.prototype.slice.call(document.querySelectorAll('.navbar-burger'), 0);
        $navbarBurgers.forEach(el => {
            const $target = document.getElementById("burger-link");
            el.classList.toggle('is-active');
            $target.classList.toggle('is-active');
        });
    }
}
