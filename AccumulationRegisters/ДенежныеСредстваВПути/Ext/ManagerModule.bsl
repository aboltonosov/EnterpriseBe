﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

Функция ПолноеИмяРегистра()
	
	Возврат "РегистрНакопления.ДенежныеСредстваВПути";
	
КонецФункции

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ДанныеРегистра.Регистратор КАК Регистратор
	|ИЗ
	|	РегистрНакопления.ДенежныеСредстваВПути КАК ДанныеРегистра
	|ГДЕ
	|	ДанныеРегистра.Получатель = ЗНАЧЕНИЕ(Справочник.БанковскиеСчетаОрганизаций.ПустаяСсылка)
	|	И ДанныеРегистра.Регистратор ССЫЛКА Документ.РеализацияПодарочныхСертификатов
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеРегистра.Регистратор
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеРегистра.Регистратор КАК Регистратор
	|ИЗ
	|	РегистрНакопления.ДенежныеСредстваВПути КАК ДанныеРегистра
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ДвиженияДенежныхСредств КАК ДвиженияДС
	|	ПО ДанныеРегистра.Регистратор = ДвиженияДС.Регистратор
	|		И ДанныеРегистра.Организация = ДвиженияДС.Организация
	|		И ДанныеРегистра.Сумма = ДвиженияДС.СуммаВВалюте
	|ГДЕ
	|	ДанныеРегистра.ВидПереводаДенежныхСредств В 
	|		(ЗНАЧЕНИЕ(Перечисление.ВидыПереводовДенежныхСредств.РеализацияВалюты),
	|		ЗНАЧЕНИЕ(Перечисление.ВидыПереводовДенежныхСредств.ПриобретениеВалюты))
	|	И ТИПЗНАЧЕНИЯ(ДанныеРегистра.Регистратор) = ТИП(Документ.ПоступлениеБезналичныхДенежныхСредств)
	|	И ДвиженияДС.Регистратор ЕСТЬ NULL
	|	И ДанныеРегистра.Сумма > 0
	|";
	
	Регистраторы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Регистратор");
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра());
	РегистрыНакопления.ПрочиеАктивыПассивы.ЗарегистироватьКОбновлениюУправленческогоБаланса(Параметры, Регистраторы, ПолноеИмяРегистра());
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеРегистра.Регистратор КАК Регистратор
	|ИЗ
	|	РегистрНакопления.ДенежныеСредстваВПути КАК ДанныеРегистра
	|ГДЕ
	|	ДанныеРегистра.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПустаяСсылка)
	|	И ТИПЗНАЧЕНИЯ(ДанныеРегистра.Регистратор) В (
	|		ТИП(Документ.РеализацияПодарочныхСертификатов),
	|		ТИП(Документ.ПоступлениеБезналичныхДенежныхСредств),
	|		ТИП(Документ.ВнесениеДенежныхСредствВКассуККМ),
	|		ТИП(Документ.ВозвратПодарочныхСертификатов),
	|		ТИП(Документ.ВыемкаДенежныхСредствИзКассыККМ),
	|		ТИП(Документ.ОперацияПоПлатежнойКарте),
	|		ТИП(Документ.ОперацияПоЯндексКассе),
	|		ТИП(Документ.ОтражениеРасхожденийПриИнкассацииДенежныхСредств),
	|		ТИП(Документ.ОтчетБанкаПоОперациямЭквайринга),
	|		ТИП(Документ.ОтчетОРозничныхПродажах),
	|		ТИП(Документ.ПриходныйКассовыйОрдер),
	|		ТИП(Документ.РасходныйКассовыйОрдер),
	|		ТИП(Документ.ЧекККМ),
	|		ТИП(Документ.ЧекККМВозврат)
	|	)
	|";
	
	Регистраторы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Регистратор");
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра());
	РегистрыНакопления.ПрочиеАктивыПассивы.ЗарегистироватьКОбновлениюУправленческогоБаланса(Параметры, Регистраторы, ПолноеИмяРегистра());
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Если ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, "Справочник.КассыККМ") Тогда
		Возврат;
	КонецЕсли;
	
	Регистраторы = Новый Массив;
	Регистраторы.Добавить("Документ.РеализацияПодарочныхСертификатов");
	Регистраторы.Добавить("Документ.ПоступлениеБезналичныхДенежныхСредств");
	
	Регистраторы.Добавить("Документ.ВнесениеДенежныхСредствВКассуККМ");
	Регистраторы.Добавить("Документ.ВозвратПодарочныхСертификатов");
	Регистраторы.Добавить("Документ.ВыемкаДенежныхСредствИзКассыККМ");
	Регистраторы.Добавить("Документ.ОперацияПоПлатежнойКарте");
	Регистраторы.Добавить("Документ.ОперацияПоЯндексКассе");
	Регистраторы.Добавить("Документ.ОтражениеРасхожденийПриИнкассацииДенежныхСредств");
	Регистраторы.Добавить("Документ.ОтчетБанкаПоОперациямЭквайринга");
	Регистраторы.Добавить("Документ.ОтчетОРозничныхПродажах");
	Регистраторы.Добавить("Документ.ПриходныйКассовыйОрдер");
	Регистраторы.Добавить("Документ.РасходныйКассовыйОрдер");
	Регистраторы.Добавить("Документ.ЧекККМ");
	Регистраторы.Добавить("Документ.ЧекККМВозврат");
	
	ОбновлениеИнформационнойБазыУТ.ПерезаписатьДвиженияИзОчереди(
		Регистраторы,
		ПолноеИмяРегистра(),
		Параметры.Очередь);
		
	// Заменить хоз.операции в переоценке валютных средств
	Документы.ПереоценкаВалютныхСредств.ЗаполнитьХозОперациюИСтатьюДДС(Параметры, ПолноеИмяРегистра(), Истина);
	
	Параметры.ОбработкаЗавершена = НЕ ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяРегистра());
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли