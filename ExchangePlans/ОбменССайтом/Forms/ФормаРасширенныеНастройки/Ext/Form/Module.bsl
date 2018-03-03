﻿#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РазмерПорции = Параметры.РазмерПорции;
	КоличествоПовторений = Параметры.КоличествоПовторений;
	
КонецПроцедуры

#КонецОбласти

#Область ДействияКомандныхПанелейФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Результат = Новый Структура;
	Результат.Вставить("РазмерПорции", РазмерПорции);
	Результат.Вставить("КоличествоПовторений", КоличествоПовторений);
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Оповестить("РасширеннаяНастройка", Неопределено);
	Закрыть();
КонецПроцедуры

#КонецОбласти
