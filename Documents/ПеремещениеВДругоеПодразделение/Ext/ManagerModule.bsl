﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

Функция ДобавитьКомандыСозданияДокументов(КомандыСозданияДокументов, ДополнительныеПараметры) Экспорт
	
	ЗарплатаКадрыРасширенный.ДобавитьВКоллекциюКомандуСозданияДокументаПоМетаданнымДокумента(
		КомандыСозданияДокументов, Метаданные.Документы.ПеремещениеВДругоеПодразделение);
	
КонецФункции

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Приказ о переводе
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "ЗарплатаКадрыКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.МенеджерПечати = "Обработка.ПечатьКадровыхПриказов";
	КомандаПечати.Идентификатор = "ПФ_MXL_Т5";
	КомандаПечати.Представление = НСтр("ru = 'Приказ о переводе (Т-5)'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
КонецПроцедуры

Функция ДанныеДляРегистрацииВУчетаСтажаПФР(МассивСсылок) Экспорт
	ДанныеДляРегистрацииВУчете = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПеремещениеВДругоеПодразделениеСотрудники.Ссылка КАК Ссылка,
	|	ПеремещениеВДругоеПодразделениеСотрудники.Ссылка.ДатаПеремещения,
	|	ПеремещениеВДругоеПодразделениеСотрудники.Ссылка.ОрганизацияНовая КАК Организация,
	|	ПеремещениеВДругоеПодразделениеСотрудники.Ссылка.ПодразделениеНовое КАК Подразделение,
	|	ПеремещениеВДругоеПодразделениеСотрудники.Сотрудник,
	|	ПеремещениеВДругоеПодразделениеСотрудники.Должность,
	|	ПеремещениеВДругоеПодразделениеСотрудники.ДолжностьПоШтатномуРасписанию,
	|	ПеремещениеВДругоеПодразделениеСотрудники.Ссылка.Территория КАК Территория
	|ИЗ
	|	Документ.ПеремещениеВДругоеПодразделение.Сотрудники КАК ПеремещениеВДругоеПодразделениеСотрудники
	|ГДЕ
	|	ПеремещениеВДругоеПодразделениеСотрудники.Ссылка В(&МассивСсылок)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.СледующийПоЗначениюПоля("Ссылка") Цикл
		ДанныеДляРегистрацииВУчетеПоДокументу = УчетСтажаПФР.ДанныеДляРегистрацииВУчетеСтажаПФР();
		ДанныеДляРегистрацииВУчете.Вставить(Выборка.Ссылка, ДанныеДляРегистрацииВУчетеПоДокументу);

		Пока Выборка.Следующий() Цикл			
			ОписаниеПериода = УчетСтажаПФР.ОписаниеРегистрируемогоПериода();
			ОписаниеПериода.Сотрудник = Выборка.Сотрудник;	
			ОписаниеПериода.ДатаНачалаПериода = Выборка.ДатаПеремещения;
			ОписаниеПериода.Состояние = Перечисления.СостоянияСотрудника.Работа;
			
			РегистрируемыйПериод = УчетСтажаПФР.ДобавитьЗаписьВДанныеДляРегистрацииВУчета(ДанныеДляРегистрацииВУчетеПоДокументу, ОписаниеПериода);
										
			УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "Организация", Выборка.Организация);
			УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "Подразделение", Выборка.Подразделение);
			УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "Должность", Выборка.Должность);
			УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "ДолжностьПоШтатномуРасписанию", Выборка.ДолжностьПоШтатномуРасписанию);
			УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "Территория", Выборка.Территория);
		КонецЦикла;	
	КонецЦикла;	
		
	Возврат ДанныеДляРегистрацииВУчете;
														
КонецФункции	

#КонецОбласти

#КонецЕсли