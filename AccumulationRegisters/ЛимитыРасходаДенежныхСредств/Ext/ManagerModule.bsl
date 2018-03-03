﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеРегистра.Регистратор КАК Регистратор
	|ИЗ
	|	РегистрНакопления.ЛимитыРасходаДенежныхСредств КАК ДанныеРегистра
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.СписаниеБезналичныхДенежныхСредств.РасшифровкаПлатежа КАК Расшифровка
	|	ПО
	|		Расшифровка.Ссылка = ДанныеРегистра.Регистратор
	|
	|ГДЕ
	|	ДанныеРегистра.РасходСверхЛимита <> 0
	|	И Расшифровка.ЗаявкаНаРасходованиеДенежныхСредств <> ЗНАЧЕНИЕ(Документ.ЗаявкаНаРасходованиеДенежныхСредств.ПустаяСсылка)
	|";
	
	Регистраторы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Регистратор");
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, "РегистрНакопления.ЛимитыРасходаДенежныхСредств");
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Регистраторы = Новый Массив;
	Регистраторы.Добавить("Документ.СписаниеБезналичныхДенежныхСредств");
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазыУТ.ПерезаписатьДвиженияИзОчереди(
		Регистраторы,
		"РегистрНакопления.ЛимитыРасходаДенежныхСредств",
		Параметры.Очередь);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли