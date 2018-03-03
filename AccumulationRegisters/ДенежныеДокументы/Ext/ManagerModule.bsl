﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

Функция ПолноеИмяРегистра()
	
	Возврат "РегистрНакопления.ДенежныеДокументы";
	
КонецФункции

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеРегистра.Регистратор КАК Регистратор
	|ИЗ
	|	РегистрНакопления.ДенежныеДокументы КАК ДанныеРегистра
	|ГДЕ
	|	ДанныеРегистра.СтатьяДвиженияДенежныхСредств = ЗНАЧЕНИЕ(Справочник.СтатьиДвиженияДенежныхСредств.ПустаяСсылка)
	|	И ТИПЗНАЧЕНИЯ(ДанныеРегистра.Регистратор) В (
	|		ТИП(Документ.ВыбытиеДенежныхДокументов),
	|		ТИП(Документ.ПоступлениеДенежныхДокументов)
	|	)
	|	
	|ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		ДанныеРегистра.Регистратор КАК Регистратор
	|	ИЗ
	|		РегистрНакопления.ДенежныеДокументы КАК ДанныеРегистра
	|	ГДЕ
	|		ТИПЗНАЧЕНИЯ(ДанныеРегистра.Регистратор) = ТИП(Документ.ПереоценкаВалютныхСредств)
	|		И ДанныеРегистра.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПереоценкаДенежныхСредств)
	|";
	
	Регистраторы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Регистратор");
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра());
	РегистрыНакопления.ПрочиеАктивыПассивы.ЗарегистироватьКОбновлениюУправленческогоБаланса(Параметры, Регистраторы, ПолноеИмяРегистра());
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Регистраторы = Новый Массив;
	Регистраторы.Добавить("Документ.ВыбытиеДенежныхДокументов");
	Регистраторы.Добавить("Документ.ПоступлениеДенежныхДокументов");
	
	ОбновлениеИнформационнойБазыУТ.ПерезаписатьДвиженияИзОчереди(
		Регистраторы,
		ПолноеИмяРегистра(),
		Параметры.Очередь);
	
	// Заменить хоз.операции в переоценке валютных средств
	Документы.ПереоценкаВалютныхСредств.ЗаполнитьХозОперациюИСтатьюДДС(Параметры, ПолноеИмяРегистра(), Истина, Истина);
	
	Параметры.ОбработкаЗавершена = НЕ ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяРегистра());
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли