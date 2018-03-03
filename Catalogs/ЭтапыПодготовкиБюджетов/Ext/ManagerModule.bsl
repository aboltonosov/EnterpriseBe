﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура меняет коды переданного элемента и ближайшего элемента
// в указанном направлении
//
// Параметры:
//  Элемент  - СправочникСсылка.ЭтапыПодготовкиБюджетов - Элемент, у которого меняем код.
//  Направление  - Число - В какую сторону меняем код (+1, -1).
//
Процедура СдвинутьЭлемент(Элемент, Направление) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ЭтапыПодготовкиБюджетов.Ссылка,
	|	ЭтапыПодготовкиБюджетов.Родитель,
	|	ЭтапыПодготовкиБюджетов.Код + &Смещение КАК Код,
	|	ЭтапыПодготовкиБюджетов.Владелец
	|ПОМЕСТИТЬ ТекущийЭлемент
	|ИЗ
	|	Справочник.ЭтапыПодготовкиБюджетов КАК ЭтапыПодготовкиБюджетов
	|ГДЕ
	|	ЭтапыПодготовкиБюджетов.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЭтапыПодготовкиБюджетов.Ссылка,
	|	ВЫБОР
	|		КОГДА ЭтапыПодготовкиБюджетов.Ссылка = ТекущийЭлемент.Ссылка
	|			ТОГДА ТекущийЭлемент.Код
	|		ИНАЧЕ ЭтапыПодготовкиБюджетов.Код
	|	КОНЕЦ КАК КодПорядок,
	|	ВЫБОР
	|		КОГДА ЭтапыПодготовкиБюджетов.Ссылка = ТекущийЭлемент.Ссылка
	|			ТОГДА &Смещение
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ДопПорядок,
	|	ЭтапыПодготовкиБюджетов.Код
	|ИЗ
	|	ТекущийЭлемент КАК ТекущийЭлемент
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ЭтапыПодготовкиБюджетов КАК ЭтапыПодготовкиБюджетов
	|		ПО ТекущийЭлемент.Родитель = ЭтапыПодготовкиБюджетов.Родитель
	|			И ТекущийЭлемент.Владелец = ЭтапыПодготовкиБюджетов.Владелец
	|
	|УПОРЯДОЧИТЬ ПО
	|	КодПорядок,
	|	ДопПорядок");
	
	Запрос.УстановитьПараметр("Ссылка", Элемент);
	Запрос.УстановитьПараметр("Смещение", Направление);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Сч = 0;
	Пока Выборка.Следующий() Цикл
		Сч = Сч + 1;
		Если Сч <> Выборка.Код Тогда
			Объект = Выборка.Ссылка.ПолучитьОбъект();
			Объект.Код = Сч;
			Объект.мРежимОбновленияКода = Истина;
			Объект.Записать();
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Процедура перенумеровывает всю группу элементов
// применяется при переносе элемента в новую группу - перенумеровывается старая группа
//
// Параметры:
//  Родитель  - СправочникСсылка.ЭтапыПодготовкиБюджетов - Группа, в рамках которой следует перенумеровать.
//  ПереносимыйЭлемент  - СправочникСсылка.ЭтапыПодготовкиБюджетов - Элемент, который переносим из группы.
//
Процедура ПеренумероватьГруппуЭлементов(Родитель, ПереносимыйЭлемент) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ЭтапыПодготовкиБюджетов.Ссылка,
	|	ЭтапыПодготовкиБюджетов.Код
	|ИЗ
	|	Справочник.ЭтапыПодготовкиБюджетов КАК ЭтапыПодготовкиБюджетов
	|ГДЕ
	|	ЭтапыПодготовкиБюджетов.Родитель = &Родитель
	|	И ЭтапыПодготовкиБюджетов.Ссылка <> &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЭтапыПодготовкиБюджетов.Код");
	
	Запрос.УстановитьПараметр("Родитель", Родитель);
	Запрос.УстановитьПараметр("Ссылка", ПереносимыйЭлемент);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Сч = 0;
	Пока Выборка.Следующий() Цикл
		Сч = Сч + 1;
		Если Сч <> Выборка.Код Тогда
			Объект = Выборка.Ссылка.ПолучитьОбъект();
			Объект.Код = Сч;
			Объект.мРежимОбновленияКода = Истина;
			Объект.Записать();
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Возвращает имена блокируемых реквизитов для механизма блокирования реквизитов БСП
// 
// Возвращаемое значание:
// 	Массив - имена блокируемых реквизитов.
//		* БлокируемыйРеквизит - Строка - Имя блокируемого реквизита.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("Периодичность");
	Результат.Добавить("ПорядокВыполненияЭтапов");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

//++ НЕ УТКА

// Обработчик обновления УП.
// Перезаполняет НастройкаДействия в соответствии с новым форматом хранения.
// Меняет Действие УстановкаЛимитовРасходаДС на Прочее.
//
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЭтапыПодготовкиБюджетов.Ссылка,
	|	ЭтапыПодготовкиБюджетов.НастройкаДействия
	|ИЗ
	|	Справочник.ЭтапыПодготовкиБюджетов КАК ЭтапыПодготовкиБюджетов
	|ГДЕ
	|	ЭтапыПодготовкиБюджетов.Действие = ЗНАЧЕНИЕ(Перечисление.ТипыДействийЭтаповПодготовкиБюджетов.ВводБюджетов)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НастройкаДействия = Выборка.НастройкаДействия.Получить();
		Если ТипЗнч(НастройкаДействия) <> Тип("ТаблицаЗначений") Тогда
			Продолжить;
		КонецЕсли;
		
		АналитикаЗаполненияБюджета = Неопределено;

		ПараметрыПоиска = Новый Структура;
		ПараметрыПоиска.Вставить("Имя","ВидыБюджетов");
		Строки = НастройкаДействия.НайтиСтроки(ПараметрыПоиска);
		Если Строки.Количество() > 0 Тогда 
			ПараметрыПоиска = Новый Структура;
			ПараметрыПоиска.Вставить("Имя","АналитикаЗаполненияБюджета");
			Строки = НастройкаДействия.НайтиСтроки(ПараметрыПоиска);
			Если Строки[0].Значение.Колонки.Найти("ДоступностьОрганизация") = Неопределено Тогда
				АналитикаЗаполненияБюджета = Строки[0].Значение;
			Иначе
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		Если Не АналитикаЗаполненияБюджета = Неопределено Тогда
			АналитикаЗаполненияБюджета.Колонки.Добавить("ДоступностьОрганизация",Новый ОписаниеТипов("Булево"));
			АналитикаЗаполненияБюджета.Колонки.Добавить("ДоступностьПодразделение",Новый ОписаниеТипов("Булево"));
			АналитикаЗаполненияБюджета.Колонки.Добавить("ДоступностьСценарий",Новый ОписаниеТипов("Булево"));
			Для Сч = 1 По 6 Цикл
				АналитикаЗаполненияБюджета.Колонки.Добавить("ДоступностьАналитика"+Сч, Новый ОписаниеТипов("Булево"));
			КонецЦикла;
			Объект = Выборка.Ссылка.ПолучитьОбъект();
			Объект.НастройкаДействия = Новый ХранилищеЗначения(НастройкаДействия);
		Иначе
			СтруктураДействия = Новый Структура;
			Для Каждого Стр Из НастройкаДействия Цикл
				СтруктураДействия.Вставить(Стр.Имя,Стр.Значение);
			КонецЦикла;
			
			Если Не СтруктураДействия.Свойство("ВидБюджета") Тогда
				Продолжить;
			КонецЕсли;
			
			НовыеНастройкиДействия = Новый ТаблицаЗначений;
			НовыеНастройкиДействия.Колонки.Добавить("Имя",Новый ОписаниеТипов("Строка"));
			НовыеНастройкиДействия.Колонки.Добавить("Представление",Новый ОписаниеТипов("Строка"));
			НовыеНастройкиДействия.Колонки.Добавить("Значение",Новый ОписаниеТипов("ТаблицаЗначений"));
			
			ВидыБюджетов = Новый ТаблицаЗначений;
			ВидыБюджетов.Колонки.Добавить("ВидБюджета",Новый ОписаниеТипов("СправочникСсылка.ВидыБюджетов"));
			ВидыБюджетов.Колонки.Добавить("КлючСтроки",Новый ОписаниеТипов("УникальныйИдентификатор"));
			ВидыБюджетов.Колонки.Добавить("КлючСтрокиНастройкиАналитики",Новый ОписаниеТипов("УникальныйИдентификатор"));
			ВидыБюджетов.Колонки.Добавить("НомерСтроки",Новый ОписаниеТипов("Число"));
			ВидыБюджетов.Колонки.Добавить("ПредставлениеИзмерений",Новый ОписаниеТипов("Строка"));

			КлючСтроки = Новый УникальныйИдентификатор();
				
			СтрокаВидыБюджетов = ВидыБюджетов.Добавить();
			СтрокаВидыБюджетов.ВидБюджета = СтруктураДействия.ВидБюджета;
			СтрокаВидыБюджетов.КлючСтроки = КлючСтроки;
			СтрокаВидыБюджетов.НомерСтроки = 1;
			
			АналитикаЗаполненияБюджета = Новый ТаблицаЗначений;
			АналитикаЗаполненияБюджета.Колонки.Добавить("Сценарий",Новый ОписаниеТипов("СправочникСсылка.Сценарии"));
			АналитикаЗаполненияБюджета.Колонки.Добавить("КлючСтроки",Новый ОписаниеТипов("УникальныйИдентификатор"));
			АналитикаЗаполненияБюджета.Колонки.Добавить("Организация",Новый ОписаниеТипов("СправочникСсылка.Организации"));
			АналитикаЗаполненияБюджета.Колонки.Добавить("Подразделение",Новый ОписаниеТипов("СправочникСсылка.СтруктураПредприятия"));
			АналитикаЗаполненияБюджета.Колонки.Добавить("ДоступностьОрганизация",Новый ОписаниеТипов("Булево"));
			АналитикаЗаполненияБюджета.Колонки.Добавить("ДоступностьПодразделение",Новый ОписаниеТипов("Булево"));
			АналитикаЗаполненияБюджета.Колонки.Добавить("ДоступностьСценарий",Новый ОписаниеТипов("Булево"));

			Для Сч = 1 По 6 Цикл
				ТипАналитик = Метаданные.Документы.ЭкземплярБюджета.Реквизиты.Аналитика1.Тип;
				АналитикаЗаполненияБюджета.Колонки.Добавить("Аналитика"+Сч, ТипАналитик);
				АналитикаЗаполненияБюджета.Колонки.Добавить("ДоступностьАналитика"+Сч, Новый ОписаниеТипов("Булево"));
			КонецЦикла;
			
			Если СтруктураДействия.Свойство("Сценарий") и ЗначениеЗаполнено(СтруктураДействия.Сценарий) 
					ИЛИ СтруктураДействия.Свойство("Организация") и ЗначениеЗаполнено(СтруктураДействия.Организация) 
					ИЛИ СтруктураДействия.Свойство("Подразделение") и ЗначениеЗаполнено(СтруктураДействия.Подразделение) Тогда
					
				СтрокаВидыБюджетов.КлючСтрокиНастройкиАналитики = КлючСтроки;
				СтрокаВидыБюджетов.ПредставлениеИзмерений = НСтр("ru = 'Индивидуальные настройки'");
				
				НоваяСтрокаАналитикаЗаполненияБюджета = АналитикаЗаполненияБюджета.Добавить();
				НоваяСтрокаАналитикаЗаполненияБюджета.КлючСтроки = КлючСтроки; 
				Если СтруктураДействия.Свойство("Сценарий") Тогда
					НоваяСтрокаАналитикаЗаполненияБюджета.Сценарий = СтруктураДействия.Сценарий;
				КонецЕсли;
				Если СтруктураДействия.Свойство("Организация") Тогда
					НоваяСтрокаАналитикаЗаполненияБюджета.Организация = СтруктураДействия.Организация;
				КонецЕсли;
				Если СтруктураДействия.Свойство("Подразделение") Тогда
					НоваяСтрокаАналитикаЗаполненияБюджета.Подразделение = СтруктураДействия.Подразделение;
				КонецЕсли;
		
			КонецЕсли;

			НоваяСтрока = НовыеНастройкиДействия.Добавить();
			НоваяСтрока.Имя = "ВидыБюджетов";
			НоваяСтрока.Представление = "ВидыБюджетов";
			НоваяСтрока.Значение = ВидыБюджетов;
			
			НоваяСтрока = НовыеНастройкиДействия.Добавить();
			НоваяСтрока.Имя = "АналитикаЗаполненияБюджета";
			НоваяСтрока.Представление = "АналитикаЗаполненияБюджета";
			НоваяСтрока.Значение = АналитикаЗаполненияБюджета;

			Объект = Выборка.Ссылка.ПолучитьОбъект();
			Объект.НастройкаДействия = Новый ХранилищеЗначения(НовыеНастройкиДействия);
		КонецЕсли;
		
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(Объект);
		
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЭтапыПодготовкиБюджетов.Ссылка
	|ИЗ
	|	Справочник.ЭтапыПодготовкиБюджетов КАК ЭтапыПодготовкиБюджетов
	|ГДЕ
	|	ЭтапыПодготовкиБюджетов.Действие = ЗНАЧЕНИЕ(Перечисление.ТипыДействийЭтаповПодготовкиБюджетов.УстановкаЛимитовРасходаДС)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Объект = Выборка.Ссылка.ПолучитьОбъект();
		Объект.Действие = Перечисления.ТипыДействийЭтаповПодготовкиБюджетов.Прочее;
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(Объект);
	КонецЦикла;
	
КонецПроцедуры

//-- НЕ УТКА

#КонецОбласти

#КонецОбласти


#КонецЕсли