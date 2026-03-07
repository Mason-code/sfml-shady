#include <iostream>
#include <vector>
#include <SFML/Audio.hpp>
#include <SFML/Graphics.hpp>

int main()
{
    sf::RenderWindow window(sf::VideoMode({ 800, 800 }), "My window");
    sf::Clock clock;
    sf::Vector2i lastDownPosition = {};
    sf::Vector2i lastClickPosition = {};

    //SHADERS!!!!!!
    sf::Shader shader;
    std::string fragAddress = "shaders/tutorialPattern.frag";
    if (!shader.isAvailable()) 
        std::cerr << "SHADERS_WILL_NOT_WORK_ON_THIS_SYSTEM" << std::endl;
    if (!shader.loadFromFile(fragAddress, sf::Shader::Type::Fragment))
        std::cerr << "ERROR::COULD_NOT_LOAD_SHADERS" << std::endl;
    sf::Vector2 windowSize = window.getSize();
    sf::RectangleShape shaderDisplayRect({ static_cast<float>(windowSize.x), static_cast<float>(windowSize.y)});

    while (window.isOpen())
    {
        while (const std::optional event = window.pollEvent())
        {

            if (event->is<sf::Event::MouseButtonPressed>() || sf::Mouse::isButtonPressed(sf::Mouse::Button::Left))
                lastDownPosition = sf::Mouse::getPosition();
            if (event->is<sf::Event::Closed>())
                window.close();
        }

        // frag data
        shader.setUniform("iTime", clock.getElapsedTime().asSeconds());
        shader.setUniform("iMouse_xy", lastDownPosition);
        shader.setUniform("iMouse_zw", lastClickPosition);
        shader.setUniform("iResolution", sf::Glsl::Vec2(window.getSize())); 

        window.clear(sf::Color::Black);
        window.draw(shaderDisplayRect, &shader);
        window.display();
    }
}