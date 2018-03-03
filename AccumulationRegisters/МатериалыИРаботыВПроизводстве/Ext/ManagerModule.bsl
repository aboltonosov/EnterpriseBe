﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

// Обработчик обновления УТ 11.3.1
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт

	ПолноеИмяРегистра = "РегистрНакопления.МатериалыИРаботыВПроизводстве";
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоДвижения = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = ПолноеИмяРегистра;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеРегистра.Регистратор КАК Ссылка
	|ИЗ
	|	РегистрНакопления.МатериалыИРаботыВПроизводстве КАК ДанныеРегистра
	|ГДЕ
	|	(ДанныеРегистра.АналитикаУчетаНоменклатуры.Назначение <> ДанныеРегистра.Назначение
	|		И ДанныеРегистра.Назначение <> ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|		И ДанныеРегистра.АналитикаУчетаНоменклатуры <> ЗНАЧЕНИЕ(Справочник.КлючиАналитикиУчетаНоменклатуры.ПустаяСсылка))
	|	ИЛИ (ДанныеРегистра.АналитикаУчетаПродукции.Назначение <> ДанныеРегистра.Назначение
	|		И ДанныеРегистра.Назначение <> ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|		И ДанныеРегистра.АналитикаУчетаПродукции <> ЗНАЧЕНИЕ(Справочник.КлючиАналитикиУчетаНоменклатуры.ПустаяСсылка))
	|");
	
	Регистраторы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Регистраторы, ДополнительныеПараметры);	
	
	//++ НЕ УТ
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПеремещениеМатериаловВПроизводствеМатериалыИРаботы.Ссылка
	|ИЗ
	|	Документ.ПеремещениеМатериаловВПроизводстве.МатериалыИРаботы КАК ПеремещениеМатериаловВПроизводствеМатериалыИРаботы
	|ГДЕ
	|	ПеремещениеМатериаловВПроизводствеМатериалыИРаботы.СтатусУказанияСерий = 6
	|	И ПеремещениеМатериаловВПроизводствеМатериалыИРаботы.СтатусУказанияСерийОтправитель = 5";
	Регистраторы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);
	//-- НЕ УТ
	
КонецПроцедуры

// Обработчик обновления заполняет новый реквизит "Назначение" в справочнике "Ключи аналитики учета номенклатуры",
// и обновляет движения по регистру.
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт

	ПолноеИмяРегистра = "РегистрНакопления.МатериалыИРаботыВПроизводстве";
	ИмяРегистра = СтрРазделить(ПолноеИмяРегистра, ".", Ложь)[1];
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоДвижения = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = ПолноеИмяРегистра;
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьРегистраторыРегистраДляОбработки(Параметры.Очередь, Неопределено, ПолноеИмяРегистра);
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	Движения.Регистратор              КАК Регистратор,
	|	Движения.Период                   КАК Период,
	|	Движения.ВидДвижения              КАК ВидДвижения,
	|	Движения.Организация                       КАК Организация,
	|	Движения.Номенклатура                      КАК Номенклатура,
	|	Движения.Характеристика                    КАК Характеристика,
	|	Движения.Подразделение                     КАК Подразделение,
	|	Движения.Серия                             КАК Серия,
	|	Движения.Назначение                        КАК Назначение,
	|	Движения.УдалитьАналитикаУчетаНоменклатуры КАК УдалитьАналитикаУчетаНоменклатуры,
	|	Движения.Количество               КАК Количество,
	|	Движения.СтатьяКалькуляции             КАК СтатьяКалькуляции,
	|	Движения.ЗаказНаПроизводство           КАК ЗаказНаПроизводство,
	|	Движения.КодСтрокиПродукция            КАК КодСтрокиПродукция,
	|	Движения.Этап                          КАК Этап,
	|	Движения.ДатаРегистратора              КАК ДатаРегистратора,
	|	Движения.НалогообложениеНДС            КАК НалогообложениеНДС,
	|	ВЫБОР КОГДА НЕ АналитикаПродукции.КлючАналитики ЕСТЬ NULL
	|		И КлючиПродукции.Назначение = ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|		И Движения.Назначение <> ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|		И Движения.АналитикаУчетаПродукции <> ЗНАЧЕНИЕ(Справочник.КлючиАналитикиУчетаНоменклатуры.ПустаяСсылка)
	|		ТОГДА АналитикаПродукции.КлючАналитики
	|		ИНАЧЕ Движения.АналитикаУчетаПродукции
	|	КОНЕЦ                                  КАК АналитикаУчетаПродукции,
	|	Движения.Спецификация                  КАК Спецификация,
	|	Движения.СтатьяРасходов                КАК СтатьяРасходов,
	|	Движения.АналитикаРасходов             КАК АналитикаРасходов,
	|	Движения.ПодразделениеПолучатель       КАК ПодразделениеПолучатель,
	|	Движения.Первичное                     КАК Первичное,
	|	ВЫБОР КОГДА НЕ Аналитика.КлючАналитики ЕСТЬ NULL
	|			И Ключи.Назначение = ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|			И Движения.АналитикаУчетаНоменклатуры.Назначение <> Движения.Назначение
	|			И Движения.Назначение <> ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|			И Движения.АналитикаУчетаНоменклатуры <> ЗНАЧЕНИЕ(Справочник.КлючиАналитикиУчетаНоменклатуры.ПустаяСсылка)
	|		ТОГДА Аналитика.КлючАналитики
	|		ИНАЧЕ Движения.АналитикаУчетаНоменклатуры
	|	КОНЕЦ                                  КАК АналитикаУчетаНоменклатуры,
	|	Движения.БазаРаспределения             КАК БазаРаспределения,
	|
	|	ВЫБОР КОГДА Аналитика.КлючАналитики ЕСТЬ NULL
	|			И Движения.АналитикаУчетаНоменклатуры.Назначение <> Движения.Назначение
	|			И Движения.Назначение <> ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|			И Ключи.Назначение = ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|			И Движения.АналитикаУчетаНоменклатуры <> ЗНАЧЕНИЕ(Справочник.КлючиАналитикиУчетаНоменклатуры.ПустаяСсылка)
	|		ИЛИ (АналитикаПродукции.КлючАналитики ЕСТЬ NULL
	|			И Движения.АналитикаУчетаПродукции.Назначение <> Движения.Назначение
	|			И Движения.Назначение <> ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|			И КлючиПродукции.Назначение = ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|			И Движения.АналитикаУчетаПродукции <> ЗНАЧЕНИЕ(Справочник.КлючиАналитикиУчетаНоменклатуры.ПустаяСсылка))
	|		ТОГДА 0
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК КлючиИнициализированы
	|ИЗ
	|	РегистрНакопления.МатериалыИРаботыВПроизводстве КАК Движения
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаНоменклатуры КАК Ключи
	|	ПО Ключи.Ссылка = Движения.АналитикаУчетаНоменклатуры
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	|	ПО Ключи.Номенклатура = Аналитика.Номенклатура
	|		И Ключи.Характеристика = Аналитика.Характеристика
	|		И Ключи.Серия = Аналитика.Серия
	|		И Ключи.Склад = Аналитика.Склад
	|		И Ключи.СтатьяКалькуляции = Аналитика.СтатьяКалькуляции
	|		И Движения.Назначение = Аналитика.Назначение
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаНоменклатуры КАК КлючиПродукции
	|	ПО КлючиПродукции.Ссылка = Движения.АналитикаУчетаПродукции
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаНоменклатуры КАК АналитикаПродукции
	|	ПО КлючиПродукции.Номенклатура = АналитикаПродукции.Номенклатура
	|		И КлючиПродукции.Характеристика = АналитикаПродукции.Характеристика
	|		И КлючиПродукции.Серия = АналитикаПродукции.Серия
	|		И КлючиПродукции.Склад = АналитикаПродукции.Склад
	|		И КлючиПродукции.СтатьяКалькуляции = АналитикаПродукции.СтатьяКалькуляции
	|		И Движения.Назначение = АналитикаПродукции.Назначение
	|
	|ГДЕ
	|	Движения.Регистратор = &Регистратор
	|
	|УПОРЯДОЧИТЬ ПО
	|	КлючиИнициализированы,
	|	НомерСтроки
	|";
	
	Пока Выборка.Следующий() Цикл
		
		Регистратор = Выборка.Регистратор;
		
		НачатьТранзакцию();
		Попытка
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяРегистра + ".НаборЗаписей");
			ЭлементБлокировки.УстановитьЗначение("Регистратор", Регистратор);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;

			Блокировка.Заблокировать();
			
			Набор = РегистрыНакопления.МатериалыИРаботыВПроизводстве.СоздатьНаборЗаписей();
			Набор.Отбор.Регистратор.Установить(Регистратор);
			
			//++ НЕ УТ
			Если ТипЗнч(Регистратор) = Тип("ДокументСсылка.ПеремещениеМатериаловВПроизводстве") Тогда
				ДопСвойства = Новый Структура;
				ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Регистратор, ДопСвойства);
				Документы.ПеремещениеМатериаловВПроизводстве.ИнициализироватьДанныеДокумента(Регистратор, ДопСвойства, ИмяРегистра);
				Результат = ДопСвойства.ТаблицыДляДвижений["Таблица" + ИмяРегистра];
			Иначе
			//-- НЕ УТ
				Запрос = Новый Запрос(ТекстЗапроса);
				Запрос.УстановитьПараметр("Регистратор", Регистратор);
				Результат = Запрос.Выполнить().Выгрузить();
				Если Результат.Количество() = 0 Тогда
					ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Регистратор, ДополнительныеПараметры);
					ЗафиксироватьТранзакцию();
					Продолжить;
				ИначеЕсли Результат[0].КлючиИнициализированы = 0 Тогда
					ТекстСообщения = НСтр("ru = 'есть необновленные ключи. Необходимо перепровести документ вручную.'");
					ВызватьИсключение ТекстСообщения;
				КонецЕсли;
			//++ НЕ УТ
			КонецЕсли;
			//-- НЕ УТ
		
			Набор.Загрузить(Результат);
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(Набор);
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ОбновлениеИнформационнойБазыУТ.СообщитьОНеудачнойОбработке(Регистратор);
		КонецПопытки;
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяРегистра);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли